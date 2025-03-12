#!/usr/bin/env bash

topdir="$(pwd)"
INSTALL_ROOT="${INSTALL_ROOT:-/container}"
STAGE_DIR="${STAGE_DIR:-/tmp}"

mkdir -p ${INSTALL_ROOT}/miniconda3 \
    && env \
    && cd ${STAGE_DIR} && wget --quiet "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" \
    && bash ./Miniforge3-$(uname)-$(uname -m).sh -b -u -p ${INSTALL_ROOT}/miniforge \
    && source ${INSTALL_ROOT}/miniforge/etc/profile.d/conda.sh \
    && conda --version

if [ -w /container/ ]; then
    ln -sf ${INSTALL_ROOT}/miniforge/etc/profile.d/conda.sh /container/init-conda.sh \
        && echo -e "\n# Miniconda" >> /container/config_env.sh \
        && echo "source ${INSTALL_ROOT}/miniforge/etc/profile.d/conda.sh" >> /container/config_env.sh
fi
