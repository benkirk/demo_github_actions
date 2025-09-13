#!/usr/bin/env bash

set -ex

#-------------------------------------------------------------------------bh-
# Common Configuration Environment:

SCRIPTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source ${SCRIPTDIR}/build_common.cfg ||
	source /container/extras/build_common.cfg ||
	{
		echo "cannot locate a suitable build_common.cfg!!"
		exit 1
	}
#-------------------------------------------------------------------------eh-

export KOKKOS_VERSION="${KOKKOS_VERSION:-4.5.01}"

KOKKOS_SRC="${STAGE_DIR}/kokkos-${KOKKOS_VERSION}"
KOKKOS_BUILD_DIR="${KOKKOS_SRC}/BUILD"
KOKKOS_INSTALL_DIR="${INSTALL_ROOT}/kokkos/${KOKKOS_VERSION}"

#--------------------------------------------------------------------------------
# prep source
[ -d "${KOKKOS_SRC}" ] || git clone --branch ${KOKKOS_VERSION} --depth=1 https://github.com/kokkos/kokkos.git ${KOKKOS_SRC}
cd ${KOKKOS_SRC} && git clean -xdf .

mkdir -p ${KOKKOS_BUILD_DIR}

#--------------------------------------------------------------------------------
# compile

#    -DKokkos_ARCH_HOPPER90=ON \
#    -DKokkos_ARCH_AMPERE80=ON \
# -DKokkos_ARCH_VOLTA70=ON \

kokkos_cuda_opts="-DKokkos_ENABLE_CUDA=OFF"
kokkos_rocm_opts="-DKokkos_ENABLE_HIP=OFF"

case "|${CUDA_HOME}|${ROCM_HOME}|" in
"|"*"cuda"*"|")
	kokkos_cuda_opts="-DKokkos_ENABLE_CUDA=ON -DKokkos_ARCH_AMPERE80=ON"
	;;
"|"*"rocm"*"|")
	kokkos_rocm_opts="-DKokkos_ENABLE_HIP=ON"
	;;
esac

# ref: https://kokkos.org/kokkos-core-wiki/keywords.html
cmake \
	-B ${KOKKOS_BUILD_DIR} \
	-DKokkos_ENABLE_SERIAL=ON \
	-DKokkos_ENABLE_OPENMP=ON \
	-DKokkos_ENABLE_THREADS=OFF \
	${kokkos_cuda_opts} ${kokkos_rocm_opts} \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_INSTALL_PREFIX=${KOKKOS_INSTALL_DIR} \
	-DKokkos_ENABLE_BENCHMARKS=OFF \
	-DKokkos_ENABLE_EXAMPLES=ON \
	-DKokkos_ENABLE_TESTS=OFF \
	-S ${KOKKOS_SRC}

cmake \
	--build ${KOKKOS_BUILD_DIR} \
	--parallel ${MAKE_J_PROCS:-$(nproc)}

find ${KOKKOS_BUILD_DIR} -type f -executable -ls

cmake --install ${KOKKOS_BUILD_DIR}

#--------------------------------------------------------------------------------
# build an example
cd ${KOKKOS_SRC}/example/build_cmake_installed
mkdir ./build
cmake \
	-B ./build \
	-S . \
	-DKokkos_ROOT=${KOKKOS_INSTALL_DIR}

cmake \
	--build ./build \
	--parallel ${MAKE_J_PROCS:-$(nproc)}

OMP_PROC_BIND=spread ./build/example 4096

exit 0
