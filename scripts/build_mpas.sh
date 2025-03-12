#!/usr/bin/env bash

set -ex

export MPAS_VERSION="${MPAS_VERSION:-8.2.2}"

topdir="$(pwd)"
INSTALL_ROOT="${INSTALL_ROOT:-/container}"
STAGE_DIR="${STAGE_DIR:-/tmp}"

cd ${STAGE_DIR}
rm -rf ${STAGE_DIR}/*

curl -sSL https://github.com/MPAS-Dev/MPAS-Model/archive/refs/tags/v${MPAS_VERSION}.tar.gz | tar xz
cd ./MPAS-Model-*/

export PIO_ROOT=${PIO}

case "${COMPILER_FAMILY}" in
    "aocc")
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
