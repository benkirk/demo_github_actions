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

export ESMF_VERSION="${ESMF_VERSION:-8.8.0}"

cd ${STAGE_DIR}
if [ ! -d ${STAGE_DIR}/esmf-v${ESMF_VERSION} ]; then
	rm -rf ${STAGE_DIR}/esmf*
	git clone --branch v${ESMF_VERSION} --depth=1 https://github.com/esmf-org/esmf esmf-v${ESMF_VERSION}
fi
cd ${STAGE_DIR}/esmf-v${ESMF_VERSION}
pwd
git clean -xdf .

case "${COMPILER_FAMILY}" in
"aocc") export ESMF_COMPILER="aocc" ;;
"gcc") export ESMF_COMPILER="gfortran" ;;
"oneapi") export ESMF_COMPILER="intel" ;;
"nvhpc") export ESMF_COMPILER="nvhpc" ;;
"clang") export ESMF_COMPILER="llvm" ;;
*)
	echo "ERROR: Unknown COMPILER_FAMILY=${COMPILER_FAMILY}"
	exit 1
	;;
esac

case "${MPI_FAMILY}" in
"openmpi") export ESMF_COMM="openmpi" ;;
"mpich"*) export ESMF_COMM="mpich3" ;;
*)
	echo "ERROR: Unknown MPI_FAMILY=${MPI_FAMILY}"
	exit 1
	;;
esac

export ESMF_DIR="$(pwd)"
export ESMF_ABI="64"
export ESMF_NETCDF="nc-config"
export ESMF_PNETCDF="pnetcdf-config"
export ESMF_PIO="external"
export ESMF_PIO_INCLUDE="${PIO}/include"
export ESMF_PIO_LIBPATH="${PIO}/lib"
export ESMF_INSTALL_PREFIX="${INSTALL_ROOT}/esmf/v${ESMF_VERSION}"

make --no-print-directory --jobs ${MAKE_J_PROCS:-$(nproc)}
#make --no-print-directory check
make install
