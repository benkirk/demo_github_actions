#!/usr/bin/env bash

set -ex

#-------------------------------------------------------------------------bh-
# Common Configuration Environment:

SCRIPTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)"
source ${SCRIPTDIR}/build_common.cfg \
    || source /container/extras/build_common.cfg \
    || {
        echo "cannot locate a suitable build_common.cfg!!"
        exit 1
    }
#-------------------------------------------------------------------------eh-

export CUDA_SAMPLES_VERSION="${CUDA_SAMPLES_VERSION:-v${CUDA_VERSION}}"

CUDA_SAMPLES_SRC="${STAGE_DIR}/cuda_samples-${CUDA_SAMPLES_VERSION}"
CUDA_SAMPLES_BUILD_DIR="${CUDA_SAMPLES_SRC}/BUILD"
CUDA_SAMPLES_INSTALL_DIR="${INSTALL_ROOT}/cuda_samples/${CUDA_SAMPLES_VERSION}"

#--------------------------------------------------------------------------------
# prep source
if [[ ! -d "${CUDA_SAMPLES_SRC}" ]]; then
    git clone --branch ${CUDA_SAMPLES_VERSION} --depth=1 \
        https://github.com/NVIDIA/cuda-samples.git \
        ${CUDA_SAMPLES_SRC}
    cd ${CUDA_SAMPLES_SRC}
    # remove sample program that depends on static CUFFT; we probably removed that library
    # the container image.
    patch -p1 << 'EOF'
diff --git a/Samples/4_CUDA_Libraries/CMakeLists.txt b/Samples/4_CUDA_Libraries/CMakeLists.txt
index e425989..69130ba 100644
--- a/Samples/4_CUDA_Libraries/CMakeLists.txt
+++ b/Samples/4_CUDA_Libraries/CMakeLists.txt
@@ -30,5 +30,4 @@ add_subdirectory(simpleCUBLAS_LU)
 add_subdirectory(simpleCUFFT)
 add_subdirectory(simpleCUFFT_2d_MGPU)
 add_subdirectory(simpleCUFFT_MGPU)
-add_subdirectory(simpleCUFFT_callback)
 add_subdirectory(watershedSegmentationNPP)
EOF
fi

cd ${CUDA_SAMPLES_SRC} && git clean -xdf .

mkdir -p ${CUDA_SAMPLES_BUILD_DIR}
cd ${CUDA_SAMPLES_BUILD_DIR}

# special compiler flags
case "${COMPILER_FAMILY}" in
    "gcc") ;;
    "aocc") ;;
    "oneapi")
        EXTRA_CMAKE_ARGS="-DOpenMP_CXX_FLAGS=-fopenmp"
        ;;
    "nvhpc")
        libomp=$(ls ${NVCOMPILERS}/*/${NVHPC_VERSION}/*/lib/libomp.so)
        EXTRA_CMAKE_ARGS="-DOpenMP_CXX_FLAGS=-fopenmp -DOpenMP_CXX_LIB_NAMES=omp -DOpenMP_omp_LIBRARY=${libomp}"
        ;;
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
