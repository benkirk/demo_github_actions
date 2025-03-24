#!/usr/bin/env bash

set -ex

#----------------------------------------------------------------------------
# environment
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${SCRIPTDIR}/build_common.cfg || { echo "cannot locate ${SCRIPTDIR}/build_common.cfg!!"; exit 1; }
#----------------------------------------------------------------------------

export PETSC_VERSION="${PETSC_VERSION:-3.21.5}"


petsc_cuda_args="--disable-cuda"
case "|${CUDA_HOME}|${ROCM_HOME}|" in
    "|"*"cuda"*"|")
        petsc_cuda_args="--enable-cuda --CUDAOPTFLAGS=-O3 --with-cuda-arch=80 --with-viennacl=1 --download-viennacl=yes --with-raja=1 --download-raja=yes"
        ;;
    "|"*"rocm"*"|")
        ;;
esac

case "${MPI_FAMILY}" in
    "openmpi"*)
        mpiexec_args="--allow-run-as-root"
        ;;
    "mpich")
        export MPIR_CVAR_ENABLE_GPU=0
        ;;
esac

cd ${STAGE_DIR}
rm -rf ${STAGE_DIR}/petsc*
curl -sSL  https://web.cels.anl.gov/projects/petsc/download/release-snapshots/petsc-${PETSC_VERSION}.tar.gz | tar xz
cd ./petsc-${PETSC_VERSION}

#BLAS_LAPACK="-L${NCAR_ROOT_MKL}/lib -Wl,-rpath,${NCAR_ROOT_MKL}/lib -lmkl_intel_lp64 -lmkl_sequential -lmkl_core"
unset CC CXX FC F77
export PETSC_DIR=$(pwd)
export PETSC_ARCH="container"

./configure --help
./configure \
    --prefix=${INSTALL_ROOT}/petsc/${PETSC_VERSION} \
    --download-fblaslapack=1 \
    --with-cc=$(which mpicc) --COPTFLAGS="-O3" CFLAGS="${CFLAGS}" \
    --with-cxx=$(which mpicxx) --CXXOPTFLAGS="-O3" CXXFLAGS="${CXXFLAGS}" \
    --with-fc=$(which mpif90) --FOPTFLAGS="-O3" FCFLAGS="${FCFLAGS}" \
    --with-shared-libraries --with-debugging=0 \
    --with-hypre=1        --download-hypre=yes \
    --with-metis=1        --download-metis=yes \
    --with-parmetis=1     --download-parmetis=yes \
    --with-scalapack=1    --download-scalapack=yes \
    --with-suitesparse=1  --download-suitesparse=yes ${petsc_cuda_args} \
    || { cat configure.log; exit 1; }

#     --with-blaslapack-lib="${BLAS_LAPACK}" \

make MAKE_NP=$(nproc)
make install
make PETSC_DIR=${INSTALL_ROOT}/petsc/${PETSC_VERSION} PETSC_ARCH="" MPIEXEC="mpiexec ${mpiexec_args}" check
