#!/usr/bin/env bash

set -ex

#----------------------------------------------------------------------------
# environment
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${SCRIPTDIR}/build_common.cfg || { echo "cannot locate ${SCRIPTDIR}/build_common.cfg!!"; exit 1; }
#----------------------------------------------------------------------------

export WRF_VERSION="${WRF_VERSION:-4.6.1}"
export WPS_VERSION="${WPS_VERSION:-4.6.0}"

# default WRF & WPS-specific CMake args; set-if-unset
WRF_CMAKE_ARGS=${WRF_CMAKE_ARGS:-"-DENABLE_CHEM=OFF -DENABLE_KPP=OFF"}
WPS_CMAKE_ARGS=${WPS_CMAKE_ARGS:-""}

source /etc/os-release
id_tag="|${PLATFORM_ID}|${VERSION_CODENAME}|${ID}|"
echo "${id_tag}"

case "${id_tag}" in

    *"|platform:el8|"*|*"|platform:el9|"*)
        dnf -y --enablerepo crb install \
            cmake \
            csh time file hostname perl \
            file flex byacc \
            libtirpc-devel \
            libpng-devel \
            || true
        ;;
    *"|leap|"*)
        ${PKG_INSTALL_CMD} \
            cmake \
            csh time file hostname perl \
            file flex byacc \
            libtirpc-devel \
            libpng16-devel \
            || true
        ;;
    *"|noble|"*)
        ${PKG_INSTALL_CMD} wget curl csh m4 gcc g++ gfortran file make cmake \
            || true
        ;;
    *)
        exit 1
        ;;
esac

cd ${STAGE_DIR}
rm -rf ${STAGE_DIR}/*

cd ${STAGE_DIR} \
    && curl --retry 3 --retry-delay 5 -sSL https://github.com/wrf-model/WRF/releases/download/v${WRF_VERSION}/v${WRF_VERSION}.tar.gz | tar xz \
    && cd WRFV${WRF_VERSION} \
    && env \
    && sed -i 's/gcc/mpicc/g' arch/configure.defaults \
    && sed -i 's/gfortran/mpifort/g' arch/configure.defaults \
    && ./configure_new -i ${INSTALL_ROOT}/wrf/${WRF_VERSION} -- ${WRF_CMAKE_ARGS} ${EXTRA_CMAKE_ARGS} <<< $'0\n0\n1\n0\nY\nN\nN' \
    && ./compile_new --jobs ${MAKE_J_PROCS:-$(nproc)} \
    && sudo docker-clean

# CONFIGURE & COMPILE WPS ${WPS_VERSION}
# (WPS does not yet recogize Linux aarch64 gfortran, but the conf is the same as x86_64)
cd ${STAGE_DIR} \
    && curl --retry 3 --retry-delay 5 -sSL https://github.com/wrf-model/WPS/archive/refs/tags/v${WPS_VERSION}.tar.gz | tar xz \
    && cd WPS-${WPS_VERSION} \
    && export WRF_ROOT=${INSTALL_ROOT}/wrf/${WRF_VERSION} \
    && export INCLUDE="/usr/include:" \
    && sed -i 's/Linux x86_64, gfortran/Linux x86_64 aarch64, gfortran/g' arch/configure.defaults \
    && ./configure_new -i ${INSTALL_ROOT}/wps/${WPS_VERSION} -- ${WPS_CMAKE_ARGS} ${EXTRA_CMAKE_ARGS} <<< $'0\nN\nY\nY' \
    && ./compile_new --jobs ${MAKE_J_PROCS:-$(nproc)} \
    && sudo docker-clean
