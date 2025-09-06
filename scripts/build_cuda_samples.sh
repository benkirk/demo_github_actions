#!/usr/bin/env bash

set -ex

#----------------------------------------------------------------------------
# environment
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${SCRIPTDIR}/build_common.cfg || { echo "cannot locate ${SCRIPTDIR}/build_common.cfg!!"; exit 1; }
#----------------------------------------------------------------------------

export CUDA_SAMPLES_VERSION="${CUDA_SAMPLES_VERSION:v${CUDA_VERSION}}}"

CUDA_SAMPLES_SRC="${STAGE_DIR}/cuda_samples-${CUDA_SAMPLES_VERSION}"
CUDA_SAMPLES_BUILD_DIR="${CUDA_SAMPLES_SRC}/BUILD"
CUDA_SAMPLES_INSTALL_DIR="${INSTALL_ROOT}/cuda_samples/${CUDA_SAMPLES_VERSION}"

#--------------------------------------------------------------------------------
# prep source
[ -d "${CUDA_SAMPLES_SRC}" ] || \
    git clone --branch ${CUDA_SAMPLES_VERSION} --depth=1 \
        https://github.com/NVIDIA/cuda-samples.git \
        ${CUDA_SAMPLES_SRC}

cd ${CUDA_SAMPLES_SRC} && git clean -xdf .

mkdir -p ${CUDA_SAMPLES_BUILD_DIR}
cd ${CUDA_SAMPLES_BUILD_DIR}


# special compiler flags
case "${COMPILER_FAMILY}" in
    "gcc")    ;;
    "oneapi") EXTRA_CMAKE_ARGS='-DOpenMP_CXX_FLAGS="-fopenmp"' ;;
    "nvhpc")  EXTRA_CMAKE_ARGS="-DOpenMP_CXX_FLAGS=\"-fopenmp\" -DOpenMP_CXX_LIB_NAMES=\"omp\" -DOpenMP_omp_LIBRARY=\"$(find /container/nvhpc -type f -name libomp.so)\"" ;;
    *)
        echo "ERROR: Unknown COMPILER_FAMILY=${COMPILER_FAMILY}"
        exit 1
        ;;
esac

# build
cmake ${EXTRA_CMAKE_ARGS} \
      ${CUDA_SAMPLES_SRC}

make -j ${MAKE_J_PROCS}


# run
cd ${CUDA_SAMPLES_SRC}

python3 run_tests.py --output ./test --dir ${CUDA_SAMPLES_BUILD_DIR}/Samples --config test_args.json

docker-clean

exit 0
