#!/usr/bin/env bash

set -ex

#----------------------------------------------------------------------------
# environment
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${SCRIPTDIR}/build_common.cfg \
    || source /container/extras/build_common.cfg \
    || { echo "cannot locate ${SCRIPTDIR}/build_common.cfg!!"; exit 1; }
#----------------------------------------------------------------------------

export MURAM_VERSION="build_tweaks"

cd ${STAGE_DIR}
if [ ! -d ${STAGE_DIR}/muram-${MURAM_VERSION} ]; then
    rm -rf ${STAGE_DIR}/muram*
    git clone --branch ${MURAM_VERSION} --depth=1 https://github.com/benkirk/MURaM_main muram-${MURAM_VERSION}
fi
cd ${STAGE_DIR}/muram-${MURAM_VERSION}
pwd
git clean -xdf .


export MURaM_HOME_DIR="$(pwd)"
#export FFT_MODE="FFTW"
export FFT_MODE="HEFFTE"
export FFTW3_HOME="${FFTW_ROOT}"
export HEFFTE_HOME="${HEFFTE_ROOT}"
export HEFFTELIBDIR="-L${HEFFTE_HOME}/lib64/"
export OPT="-O2"
export DBG=""

export CC="$(which mpicc)"
export CCC="$(which mpicxx) -std=c++11"
export LD="${CCC}"

make
