#!/usr/bin/env bash

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

mkdir -p ${INSTALL_ROOT}/miniconda3 &&
	env &&
	cd ${STAGE_DIR} && wget --quiet "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" &&
	bash ./Miniforge3-$(uname)-$(uname -m).sh -b -u -p ${INSTALL_ROOT}/miniforge &&
	source ${INSTALL_ROOT}/miniforge/etc/profile.d/conda.sh &&
	conda --version

if [ -w /container/ ]; then
	ln -sf ${INSTALL_ROOT}/miniforge/etc/profile.d/conda.sh /container/init-conda.sh &&
		echo -e "\n# Miniconda" >>/container/config_env.sh &&
		echo "source ${INSTALL_ROOT}/miniforge/etc/profile.d/conda.sh" >>/container/config_env.sh
fi
