#!/usr/bin/env bash

set -ex

#----------------------------------------------------------------------------
# environment
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${SCRIPTDIR}/build_common.cfg \
    || source /container/extras/build_common.cfg \
    || { echo "cannot locate ${SCRIPTDIR}/build_common.cfg!!"; exit 1; }
#----------------------------------------------------------------------------

export FASTEDDY_VERSION="${FASTEDDY_VERSION:-v3.0.0}"

FASTEDDY_DIR="${STAGE_DIR}/fasteddy-${FASTEDDY_VERSION}"

cd ${STAGE_DIR}
if [ ! -d ${FASTEDDY_DIR} ]; then
    rm -rf ${STAGE_DIR}/fasteddy*
    git clone --branch ${FASTEDDY_VERSION} --depth=1 https://github.com/NCAR/FastEddy-model ${FASTEDDY_DIR}
    cd ${FASTEDDY_DIR}
    patch -p1 <<'EOF'
diff --git a/SRC/FEMAIN/Makefile b/SRC/FEMAIN/Makefile
index b86fd83..f009405 100644
--- a/SRC/FEMAIN/Makefile
+++ b/SRC/FEMAIN/Makefile
@@ -37,8 +37,8 @@ DEFINES = -DCUB_IGNORE_DEPRECATED_CPP_DIALECT -DTHRUST_IGNORE_DEPRECATED_CPP_DIA


 TEST_CFLAGS = -Wall -m64 ${DEFINES} ${INCLUDES} ${OTHER_INCLUDES}
-ARCH_CU_FLAGS = -arch=sm_70
-TEST_CU_CFLAGS = ${ARCH_CU_FLAGS} -m64 -std=c++11 ${DEFINES} ${INCLUDES} ${OTHER_INCLUDES}
+ARCH_CU_FLAGS =
+TEST_CU_CFLAGS = ${ARCH_CU_FLAGS} -m64 ${DEFINES} ${INCLUDES} ${OTHER_INCLUDES}

 L_CPPFLAGS =

EOF
    git diff
fi

cd ${FASTEDDY_DIR}
pwd
git clean -xdf .

export MPI_DIR="$(cd $(dirname $(which mpicc))/.. && pwd)"
export NCAR_ROOT_MPI="${MPI_DIR}"

make -C ${FASTEDDY_DIR}/SRC/FEMAIN

# poor man's 'make install'
cd ${FASTEDDY_DIR}

git clean -xdf --exclude=SRC/FEMAIN/FastEddy

export FASTEDDY_INSTALL_PATH=${INSTALL_ROOT}/fasteddy/${FASTEDDY_VERSION}

mkdir -p ${FASTEDDY_INSTALL_PATH}/bin
rsync -axv \
      --exclude 'docs/' \
      --exclude '.git/' \
      ${FASTEDDY_DIR}/ ${FASTEDDY_INSTALL_PATH}/
cd ${FASTEDDY_INSTALL_PATH}/bin
ln -sf ../SRC/FEMAIN/FastEddy
ldd ${FASTEDDY_INSTALL_PATH}/bin/FastEddy
