#!/usr/bin/env bash

set -ex

#-------------------------------------------------------------------------bh-
# Common Configuration Environment
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${SCRIPTDIR}/build_common.cfg \
    || source /container/extras/build_common.cfg \
    || { echo "cannot locate ${SCRIPTDIR}/build_common.cfg!!"; exit 1; }
#-------------------------------------------------------------------------eh-

export MPAS_VERSION="${MPAS_VERSION:-8.2.2}"

cd ${STAGE_DIR}
rm -rf ${STAGE_DIR}/*

curl --retry 3 --retry-delay 5 -sSL https://github.com/MPAS-Dev/MPAS-Model/archive/refs/tags/v${MPAS_VERSION}.tar.gz | tar xz
cd ./MPAS-Model-*/

export PIO_ROOT=${PIO}

case "${COMPILER_FAMILY}" in
    "aocc"|"clang")
        compiler_target="llvm"
        ;;
    "gcc")
        compiler_target="gfortran"
        ;;
    "oneapi")
        compiler_target="intel"
        ;;
    "nvhpc")
        compiler_target="nvhpc"
        ;;
    *)
        echo "ERROR: unrecognized COMPILER_FAMILY=${COMPILER_FAMILY}"!
        exit 1
        ;;
esac

make ${compiler_target} CORE=atmosphere --jobs ${MAKE_J_PROCS:-$(nproc)}

#cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_ROOT}/mpas/${MPAS_VERSION}
#make --jobs ${MAKE_J_PROCS:-$(nproc)}
#make install
