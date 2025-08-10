#!/usr/bin/env bash

#----------------------------------------------------------------------------
# environment
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${SCRIPTDIR}/build_common.cfg || { echo "cannot locate ${SCRIPTDIR}/build_common.cfg!!"; exit 1; }
#----------------------------------------------------------------------------

OMB_VERSION="${OMB_VERSION:-7.5}"
NRANKS="${NRANKS:-4}"

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
        #mpiexec_args="--allow-run-as-root"
        ;;
    "mpich")
        export MPIR_CVAR_ENABLE_GPU=0
        ;;
esac

rm -rf ${STAGE_DIR}/*
cd ${STAGE_DIR}/
curl --retry 3 --retry-delay 5 -sSL https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-${OMB_VERSION}.tar.gz | tar xz \
    &&  cd osu-micro-benchmarks-${OMB_VERSION} \
    && ./configure --help \
    && set -x \
    && ./configure \
           --prefix=${INSTALL_ROOT}/osu-micro-benchmarks/${OMB_VERSION} ${extra_args} \
           LIBS="${CUDA_LIBS} ${ROCM_LIBS}" \
    && make --jobs ${MAKE_J_PROCS:-$(nproc)} V=0 \
    && make install-strip \
    && sudo docker-clean

cd ${topdir}

ldd ${INSTALL_ROOT}/osu-micro-benchmarks/${OMB_VERSION}/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency
mpiexec -n 2 ${mpiexec_args} ${INSTALL_ROOT}/osu-micro-benchmarks/${OMB_VERSION}/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency || true
mpiexec -n 2 ${mpiexec_args} ${INSTALL_ROOT}/osu-micro-benchmarks/${OMB_VERSION}/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bibw || true
mpiexec -n ${NRANKS} ${mpiexec_args} ${INSTALL_ROOT}/osu-micro-benchmarks/${OMB_VERSION}/libexec/osu-micro-benchmarks/mpi/collective/osu_alltoallw || true
