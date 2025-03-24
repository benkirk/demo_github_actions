#!/usr/bin/env bash

set -ex

#----------------------------------------------------------------------------
# environment
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${SCRIPTDIR}/build_common.cfg || { echo "cannot locate ${SCRIPTDIR}/build_common.cfg!!"; exit 1; }
#----------------------------------------------------------------------------

export FASTEDDY_VERSION="${FASTEDDY_VERSION:-v2.0.0}"

FASTEDDY_DIR="${STAGE_DIR}/fasteddy-${FASTEDDY_VERSION}"

cd ${STAGE_DIR}
if [ ! -d ${FASTEDDY_DIR} ]; then
    rm -rf ${STAGE_DIR}/fasteddy*
    git clone --branch ${FASTEDDY_VERSION} --depth=1 https://github.com/NCAR/FastEddy-model fasteddy-${FASTEDDY_VERSION}
    cd fasteddy-${FASTEDDY_VERSION}
    cd SRC/FEMAIN
fi

cd ${FASTEDDY_DIR}
pwd
git clean -xdf .

export MPI_DIR="$(cd $(dirname $(which mpicc))/.. && pwd)"
export NCAR_ROOT_MPI="${MPI_DIR}"

#cd ${FASTEDDY_DIR}/SRC && fe_inc= && for d in */ */*/ ; do fe_inc="-I$(pwd)/${d} ${fe_inc}" ; done

cd ${FASTEDDY_DIR}/SRC/FEMAIN

make \
    ARCH_CU_FLAGS="-arch=sm_80"

# poor man's 'make install'
cd ${FASTEDDY_DIR}

git clean -xdf --exclude=SRC/FEMAIN/FastEddy

export FASTEDDY_INSTALL_PATH=${INSTALL_ROOT}/fasteddy/${FASTEDDY_VERSION}

mkdir -p ${FASTEDDY_INSTALL_PATH}/bin
rsync -axv \
      --exclude 'docs/' \
      ${FASTEDDY_DIR}/ ${FASTEDDY_INSTALL_PATH}/
cd ${FASTEDDY_INSTALL_PATH}/bin
ln -s ../SRC/FEMAIN/FastEddy
ldd ${FASTEDDY_INSTALL_PATH}/bin/FastEddy
