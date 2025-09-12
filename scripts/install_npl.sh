#!/usr/bin/env bash

#-------------------------------------------------------------------------bh-
# Common Configuration Environment:

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source ${SCRIPTDIR}/build_common.cfg \
    || source /container/extras/build_common.cfg \
    || { echo "cannot locate a suitable build_common.cfg!!"; exit 1; }
#-------------------------------------------------------------------------eh-

set -e
source /container/config_env.sh
conda --version 2>/dev/null || ${SCRIPTDIR}/install_conda.sh && source /container/config_env.sh


if [ ! -d "${STAGE_DIR}/npl" ]; then
    git clone https://github.com/NCAR/ncar-conda.git ${STAGE_DIR}/npl
fi

cd ${STAGE_DIR}/npl
git clean -xdf .

latest_yml=$(find envs/npl/ -maxdepth 1 -name "npl*.y*ml" | sort | tail -n 1)

[ -f "${latest_yml}" ] || { echo "cannot locate latest NPL YAML file!!"; exit 1; }

case "$(uname -m)" in
    *"aarch64"*)
        sed -i 's/- libblas/#- libblas/' ${latest_yml}
        ;;
esac

git diff

conda env create -vvv --file ${latest_yml} --name npl #--prefix /container/npl/2025a
