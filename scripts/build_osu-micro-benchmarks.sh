#!/usr/bin/env bash

topdir="$(pwd)"
INSTALL_ROOT="${INSTALL_ROOT:-/container}"
STAGE_DIR="${STAGE_DIR:-/tmp}"

OMB_VERSION="${OMB_VERSION:-7.5}"

extra_args=""
mpiexec_args=""

CUDA_LIBS=""
ROCM_LIBS=""

case "|${CUDA_HOME}|${ROCM_HOME}|" in
    "|"*"cuda"*"|")
        CUDA_LIBS="-lcuda -lcudart"
        extra_args="--enable-cuda ${extra_args}"
        ;;
    "|"*"rocm"*"|")
        ROCM_LIBS="-lamdhip64"
        extra_args="--enable-rocm --enable-rcclomb CPPFLAGS=-I/opt/rocm/include/rccl ${extra_args}"
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

rm -rf ${STAGE_DIR}/*
cd ${STAGE_DIR}/
curl -sSL https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-${OMB_VERSION}.tar.gz | tar xz \
    &&  cd osu-micro-benchmarks-${OMB_VERSION} \
    && ./configure --help \
    && set -x \
    && ./configure \
           --prefix=${INSTALL_ROOT}/osu-micro-benchmarks/${OMB_VERSION} ${extra_args} \
           LIBS="${CUDA_LIBS} ${ROCM_LIBS}" \
    && make --jobs ${MAKE_J_PROCS:-$(nproc)} V=0 \
    && make install-strip \
    && (docker-clean || true)

#cd ${topdir}
#mpiexec -n 2 ${mpiexec_args} ${INSTALL_ROOT}/osu-micro-benchmarks/${OMB_VERSION}/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bibw
#mpiexec -n 6 ${mpiexec_args} ${INSTALL_ROOT}/osu-micro-benchmarks/${OMB_VERSION}/libexec/osu-micro-benchmarks/mpi/collective/osu_alltoallw
