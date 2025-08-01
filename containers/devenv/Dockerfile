ARG BASE_OS="almalinux9"

ARG COMPILER_FAMILY="gcc"
ARG MPI_FAMILY="openmpi"

#ARG FINAL_TARGET="compilers"
ARG FINAL_TARGET="fftlibs"
#ARG FINAL_TARGET="iolibs"

ARG COMPILERS_PREREQ="${BASE_OS}"
ARG CUDA_PREREQ="compilers"
ARG ROCM_PREREQ="compilers"
ARG MINIFORGE_PREREQ="${BASE_OS}"

ARG MPI_PREREQ="compilers"

ARG IOLIBS_PREREQ="mpi"
ARG MPIIOLIBS_PREREQ="iolibs"

ARG FFTLIBS_PREREQ="mpi-iolibs"

ARG TOGGLE_ENABLE_PARALLEL="--disable-parallel"
ARG TOGGLE_WITH_CUDA="--without-cuda"
ARG TOGGLE_WITH_ROCM="--without-rocm --without-hip"

################################################################################
# Part 1: various Base Operating Systems
################################################################################

#-------------------------------------------------------------------------------
# AlmaLinux v8 base stage: OS + os packages
FROM docker.io/almalinux:8 AS almalinux8
#-------------------------------------------------------------------------------
RUN cat <<EOF > /usr/bin/docker-clean
#!/bin/bash
echo "[\${0}]: cleaning temporary files from container image to reduce layer size"
[ -x "\$(command -v yum)" ] && yum clean all
[ -x "\$(command -v apt)" ] && apt clean
[ -x "\$(command -v conda)" ] && conda clean --all
[ -x "\$(command -v zypper)" ] && zypper clean -a
for dir in /tmp/* /var/tmp/* /home/jupyter/{.ccache,.cache/pip,conda-bld,.conda} /root/* /root/.[^.]* /var/lib/apt/lists /var/log/* ; do
	[ -e \${dir} ] && rm -rf \${dir} 2>/dev/null || true
done
rm -rf /tmp/*
EOF

SHELL ["/bin/bash", "-c"]
#     && yum -y update \
RUN mkdir -p /container/logs && exec &> >(tee /container/logs/base-os.log) \
    && echo "yum: initial update" \
    && set -x \
    && yum -y install dnf dnf-plugins-core \
    && dnf group list \
    && echo "GCC & build tools" \
    && dnf -y install \
           gcc gcc-c++ gcc-gfortran \
           make autoconf automake libtool \
           git wget which tar gzip bzip2 xz \
           diffutils file rsync cmake \
           emacs-nox \
           python3 \
    && mkdir -p /container \
    && echo "# Common Configs" > /container/config_env.sh \
    && echo "export PATH=${PATH}" >> /container/config_env.sh \
    && echo "export CPATH=${CPATH}" >> /container/config_env.sh \
    && echo "export LIBRARY_PATH=${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "export MAKE_J_PROCS=\${MAKE_J_PROCS:-\$(nproc)}" >> /container/config_env.sh \
    && ln -s /container/config_env.sh /etc/profile.d/z00-build-env.sh \
    && chmod a+rx /usr/bin/docker-clean \
    && cat /etc/*-release \
    && docker-clean
ENV PKG_INSTALL_CMD="dnf -y install"
SHELL ["/bin/bash", "--login", "-c"]


#-------------------------------------------------------------------------------
# AlmaLinux v9 base stage: OS + os packages
FROM docker.io/almalinux:9 AS almalinux9
#-------------------------------------------------------------------------------
RUN cat <<EOF > /usr/bin/docker-clean
#!/bin/bash
echo "[\${0}]: cleaning temporary files from container image to reduce layer size"
[ -x "\$(command -v yum)" ] && yum clean all
[ -x "\$(command -v apt)" ] && apt clean
[ -x "\$(command -v conda)" ] && conda clean --all
[ -x "\$(command -v zypper)" ] && zypper clean -a
for dir in /tmp/* /var/tmp/* /home/jupyter/{.ccache,.cache/pip,conda-bld,.conda} /root/* /root/.[^.]* /var/lib/apt/lists /var/log/* ; do
	[ -e \${dir} ] && rm -rf \${dir} 2>/dev/null || true
done
rm -rf /tmp/*
EOF

#     && yum -y update \
RUN mkdir -p /container/logs && exec &> >(tee /container/logs/base-os.log) \
    && echo "yum: initial update" \
    && set -x \
    && yum -y install dnf dnf-plugins-core \
    && dnf group list \
    && echo "GCC & build tools" \
    && dnf -y install \
           gcc gcc-c++ gcc-gfortran \
           make autoconf automake libtool \
           git wget which tar gzip bzip2 xz \
           diffutils file rsync cmake \
           emacs-nox \
           python3 \
    && mkdir -p /container \
    && echo "# Common Configs" > /container/config_env.sh \
    && echo "export PATH=${PATH}" >> /container/config_env.sh \
    && echo "export CPATH=${CPATH}" >> /container/config_env.sh \
    && echo "export LIBRARY_PATH=${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "export MAKE_J_PROCS=\${MAKE_J_PROCS:-\$(nproc)}" >> /container/config_env.sh \
    && ln -s /container/config_env.sh /etc/profile.d/z00-build-env.sh \
    && chmod a+rx /usr/bin/docker-clean \
    && cat /etc/*-release \
    && docker-clean
ENV PKG_INSTALL_CMD="dnf -y install"
SHELL ["/bin/bash", "--login", "-c"]


#-------------------------------------------------------------------------------
# AlmaLinux v10 base stage: OS + os packages
FROM docker.io/almalinux:10 AS almalinux10
#-------------------------------------------------------------------------------
RUN cat <<EOF > /usr/bin/docker-clean
#!/bin/bash
echo "[\${0}]: cleaning temporary files from container image to reduce layer size"
[ -x "\$(command -v yum)" ] && yum clean all
[ -x "\$(command -v apt)" ] && apt clean
[ -x "\$(command -v conda)" ] && conda clean --all
[ -x "\$(command -v zypper)" ] && zypper clean -a
for dir in /tmp/* /var/tmp/* /home/jupyter/{.ccache,.cache/pip,conda-bld,.conda} /root/* /root/.[^.]* /var/lib/apt/lists /var/log/* ; do
	[ -e \${dir} ] && rm -rf \${dir} 2>/dev/null || true
done
rm -rf /tmp/*
EOF

#     && yum -y update \
RUN mkdir -p /container/logs && exec &> >(tee /container/logs/base-os.log) \
    && echo "yum: initial update" \
    && set -x \
    && yum -y install dnf dnf-plugins-core \
    && dnf group list \
    && echo "GCC & build tools" \
    && dnf -y install \
           gcc gcc-c++ gcc-gfortran \
           make autoconf automake libtool \
           git wget which tar gzip bzip2 xz \
           diffutils file rsync cmake \
           emacs-nox \
           python3 \
    && mkdir -p /container \
    && echo "# Common Configs" > /container/config_env.sh \
    && echo "export PATH=${PATH}" >> /container/config_env.sh \
    && echo "export CPATH=${CPATH}" >> /container/config_env.sh \
    && echo "export LIBRARY_PATH=${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "export MAKE_J_PROCS=\${MAKE_J_PROCS:-\$(nproc)}" >> /container/config_env.sh \
    && ln -s /container/config_env.sh /etc/profile.d/z00-build-env.sh \
    && chmod a+rx /usr/bin/docker-clean \
    && cat /etc/*-release \
    && docker-clean
ENV PKG_INSTALL_CMD="dnf -y install"
SHELL ["/bin/bash", "--login", "-c"]



#-------------------------------------------------------------------------------
# OpenSUSE 15 base stage: OS + os packages
FROM docker.io/opensuse/leap AS leap
#-------------------------------------------------------------------------------
RUN cat <<EOF > /usr/bin/docker-clean
#!/bin/bash
echo "[\${0}]: cleaning temporary files from container image to reduce layer size"
[ -x "\$(command -v yum)" ] && yum clean all
[ -x "\$(command -v apt)" ] && apt clean
[ -x "\$(command -v conda)" ] && conda clean --all
[ -x "\$(command -v zypper)" ] && zypper clean -a
for dir in /tmp/* /var/tmp/* /home/jupyter/{.ccache,.cache/pip,conda-bld,.conda} /root/* /root/.[^.]* /var/lib/apt/lists /var/log/* ; do
	[ -e \${dir} ] && rm -rf \${dir} 2>/dev/null || true
done
rm -rf /tmp/*
EOF

RUN echo "basic zypper setup" \
    && set -x \
    && zypper --non-interactive refresh \
    && zypper --non-interactive update \
    && echo "GCC & build tools" \
    && zypper --non-interactive install \
              gcc gcc-c++ gcc-fortran \
              gmake autoconf automake libtool \
              git wget which tar gzip bzip2 xz \
              awk diffutils file rsync cmake \
              emacs-nox \
              python3 \
    && mkdir -p /container \
    && echo "# Common Configs" > /container/config_env.sh \
    && echo "#export PATH=${PATH}" >> /container/config_env.sh \
    && echo "#export CPATH=${CPATH}" >> /container/config_env.sh \
    && echo "#export LIBRARY_PATH=${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "#export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "export MAKE_J_PROCS=\${MAKE_J_PROCS:-\$(nproc)}" >> /container/config_env.sh \
    && ln -s /container/config_env.sh /etc/profile.d/z00-build-env.sh \
    && chmod a+rx /usr/bin/docker-clean \
    && cat /etc/*-release \
    && docker-clean
ENV PKG_INSTALL_CMD="zypper --gpg-auto-import-keys --non-interactive install"
SHELL ["/bin/bash", "--login", "-c"]



#-------------------------------------------------------------------------------
# OpenSUSE Tumbleweed base stage: OS + os packages
FROM docker.io/opensuse/tumbleweed AS tumbleweed
#-------------------------------------------------------------------------------
RUN cat <<EOF > /usr/bin/docker-clean
#!/bin/bash
echo "[\${0}]: cleaning temporary files from container image to reduce layer size"
[ -x "\$(command -v yum)" ] && yum clean all
[ -x "\$(command -v apt)" ] && apt clean
[ -x "\$(command -v conda)" ] && conda clean --all
[ -x "\$(command -v zypper)" ] && zypper clean -a
for dir in /tmp/* /var/tmp/* /home/jupyter/{.ccache,.cache/pip,conda-bld,.conda} /root/* /root/.[^.]* /var/lib/apt/lists /var/log/* ; do
	[ -e \${dir} ] && rm -rf \${dir} 2>/dev/null || true
done
rm -rf /tmp/*
EOF

RUN echo "basic zypper setup" \
    && set -x \
    && zypper --non-interactive refresh \
    && zypper --non-interactive update \
    && echo "GCC & build tools" \
    && zypper --non-interactive install \
              gcc gcc-c++ gcc-fortran \
              gmake autoconf automake libtool \
              git wget which tar gzip bzip2 xz \
              awk diffutils file rsync cmake \
              emacs-nox \
              python3 \
    && mkdir -p /container \
    && echo "# Common Configs" > /container/config_env.sh \
    && echo "#export PATH=${PATH}" >> /container/config_env.sh \
    && echo "#export CPATH=${CPATH}" >> /container/config_env.sh \
    && echo "#export LIBRARY_PATH=${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "#export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "export MAKE_J_PROCS=\${MAKE_J_PROCS:-\$(nproc)}" >> /container/config_env.sh \
    && ln -s /container/config_env.sh /etc/profile.d/z00-build-env.sh \
    && chmod a+rx /usr/bin/docker-clean \
    && cat /etc/*-release \
    && docker-clean
ENV PKG_INSTALL_CMD="zypper --gpg-auto-import-keys --non-interactive install"
SHELL ["/bin/bash", "--login", "-c"]



#-------------------------------------------------------------------------------
# Ubuntu 24.04 LTS (Noble Numbat) base stage: OS + os packages
FROM ubuntu:noble AS noble
#-------------------------------------------------------------------------------
ARG DEBIAN_FRONTEND=noninteractive
RUN cat <<EOF > /usr/bin/docker-clean
#!/bin/bash
echo "[\${0}]: cleaning temporary files from container image to reduce layer size"
[ -x "\$(command -v yum)" ] && yum clean all
[ -x "\$(command -v apt-get)" ] && apt-get clean -y && apt-get autoremove -y
[ -x "\$(command -v conda)" ] && conda clean --all
[ -x "\$(command -v zypper)" ] && zypper clean -a
for dir in /tmp/* /var/tmp/* /home/jupyter/{.ccache,.cache/pip,conda-bld,.conda} /root/* /root/.[^.]* /var/lib/apt/lists /var/log/* ; do
	[ -e \${dir} ] && rm -rf \${dir} 2>/dev/null || true
done
rm -rf /tmp/*
EOF

RUN echo "basic apt setup" \
    && set -x \
    && apt-get update \
    && apt-get autoclean \
    && apt-get install -y \
               gcc g++ gfortran \
               make autoconf automake libtool \
               git curl wget which tar gzip bzip2 xz-utils \
               emacs-nox \
               python3 \
               libxml2 \
    && mkdir -p /container \
    && echo "# Common Configs" > /container/config_env.sh \
    && echo "export PATH=${PATH}" >> /container/config_env.sh \
    && echo "export CPATH=${CPATH}" >> /container/config_env.sh \
    && echo "export LIBRARY_PATH=${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "export MAKE_J_PROCS=\${MAKE_J_PROCS:-\$(nproc)}" >> /container/config_env.sh \
    && ln -s /container/config_env.sh /etc/profile.d/z00-build-env.sh \
    && chmod a+rx /usr/bin/docker-clean \
    && cat /etc/*-release \
    && docker-clean
ENV PKG_INSTALL_CMD="apt-get install -y"
SHELL ["/bin/bash", "--login", "-c"]




#-------------------------------------------------------------------------------
# miniforge stage
FROM ${MINIFORGE_PREREQ} AS miniforge
#-------------------------------------------------------------------------------
RUN mkdir -p /container/logs && exec &> >(tee /container/logs/miniforge.log) \
    && mkdir -p /container/miniforge \
    && env \
    && cd /tmp && wget --quiet "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" \
    && bash ./Miniforge3-$(uname)-$(uname -m).sh -b -u -p /container/miniforge \
    && ln -sf /container/miniforge/etc/profile.d/conda.sh /container/init-conda.sh \
    && echo -e "\n# Miniforge" >> /container/config_env.sh \
    && echo "source /container/miniforge/etc/profile.d/conda.sh" >> /container/config_env.sh \
    && source /container/init-conda.sh \
    && conda --version \
    && docker-clean


################################################################################
# Part 2: Compilers and other toolkits
################################################################################

#-------------------------------------------------------------------------------
# GCC compilers stage (from base OS)
FROM ${COMPILERS_PREREQ} AS os-gcc
RUN echo "Selecting base OS gcc compilers" \
    && echo -e "\n# GCC compilers libraries (base OS)" >> /container/config_env.sh \
    && echo "export COMPILER_FAMILY=gcc" >> /container/config_env.sh \
    && echo "export GCC_VERSION=$(gcc -dumpfullversion)" >> /container/config_env.sh \
    && echo "export gcc_CC=$(which gcc) && export CC=\${gcc_CC}" >> /container/config_env.sh \
    && echo "export gcc_CXX=$(which g++) && export CXX=\${gcc_CXX}" >> /container/config_env.sh \
    && echo "export gcc_F77=$(which gfortran) && export F77=\${gcc_F77}" >> /container/config_env.sh \
    && echo "export gcc_FC=$(which gfortran) && export FC=\${gcc_FC}" >> /container/config_env.sh \
    && docker-clean
LABEL compiler="gcc"
LABEL gcc="os-gcc"


#-------------------------------------------------------------------------------
# GCC compilers stage
# Note, if installing CUDA, use a supported GCC!:
#   https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#host-compiler-support-policy
# ("unset LIBRARY_PATH CPATH C_INCLUDE_PATH PKG_CONFIG_PATH" fixes this on AWS/docker:)
#   g++: error: spec failure: unrecognized spec option ‘@’
#   g++: fatal error: unknown spec function ‘dumps’
FROM ${COMPILERS_PREREQ} AS gcc
#-------------------------------------------------------------------------------
ARG GCC_VERSION="13.3.0"
RUN mkdir -p /container/logs && exec &> >(tee /container/logs/gcc.log) \
    && echo "Building gcc-${GCC_VERSION}" \
    && unset LIBRARY_PATH CPATH C_INCLUDE_PATH PKG_CONFIG_PATH \
    && env \
    && GCC_INSTALL_PATH="/container/gcc/${GCC_VERSION}" \
    && cd /tmp && curl --retry 3 --retry-delay 5 -sSL https://ftpmirror.gnu.org/gnu/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.xz | tar Jx \
    && cd ./gcc-${GCC_VERSION} \
    && mkdir -p /container/logs/ \
    && ./configure --help \
    && ./contrib/download_prerequisites \
    && mkdir /tmp/gcc-build && cd /tmp/gcc-build \
    && (/tmp/gcc-${GCC_VERSION}/configure \
                 --prefix=${GCC_INSTALL_PATH} \
                 --disable-static --enable-shared \
                 --enable-languages=c,c++,fortran \
                 --disable-multilib \
                 --disable-bootstrap | tee /container/logs/gcc-configure.log \
            || cat config.log) \
    && make --no-print-directory --jobs ${MAKE_J_PROCS:-$(nproc)} V=0 | tee /container/logs/gcc-build.log \
    && make --no-print-directory install-strip | tee /container/logs/gcc-install.log \
    && echo -e "\n# GCC compilers" >> /container/config_env.sh \
    && echo "export COMPILER_FAMILY=gcc" >> /container/config_env.sh \
    && echo "export GCC_VERSION=${GCC_VERSION}" >> /container/config_env.sh \
    && echo "export PATH=/container/gcc/${GCC_VERSION}/bin:\${PATH}" >> /container/config_env.sh \
    && if [ "$(${GCC_INSTALL_PATH}/bin/gcc -dumpfullversion | cut -d'.' -f1)" -gt "$(gcc -dumpfullversion | cut -d'.' -f1) " ]; then \
         echo "export LD_LIBRARY_PATH=/container/gcc/${GCC_VERSION}/lib64:/container/gcc/${GCC_VERSION}/lib:\${LD_LIBRARY_PATH}" >> /container/config_env.sh ;\
         echo "${GCC_INSTALL_PATH}/lib" >> /etc/ld.so.conf.d/gcc-${GCC_VERSION}.conf ;\
         echo "${GCC_INSTALL_PATH}/lib64" >> /etc/ld.so.conf.d/gcc-${GCC_VERSION}.conf ;\
         ldconfig --verbose ;\
       fi \
    && source /container/config_env.sh \
    && echo "export gcc_CC=$(which gcc) && export CC=\${gcc_CC}" >> /container/config_env.sh \
    && echo "export gcc_CXX=$(which g++) && export CXX=\${gcc_CXX}" >> /container/config_env.sh \
    && echo "export gcc_F77=$(which gfortran) && export F77=\${gcc_F77}" >> /container/config_env.sh \
    && echo "export gcc_FC=$(which gfortran) && export FC=\${gcc_FC}" >> /container/config_env.sh \
    && docker-clean
LABEL compiler="gcc"
LABEL gcc="${GCC_VERSION}"



#-------------------------------------------------------------------------------
# Intel OneAPI stage
FROM ${COMPILERS_PREREQ} AS oneapi
#-------------------------------------------------------------------------------
# https://github.com/spack/spack/blob/develop/var/spack/repos/builtin/packages/intel-oneapi-compilers/package.py
# Intel compilers do not -rpath their own libraries, relying instead on LD_LIBRARY_PATH
# We'd rather not need that, so add to the system search path
ARG ONEAPI_VERSION="2025.2.0"
ARG ONEAPI_CC_URL="https://registrationcenter-download.intel.com/akdlm/IRC_NAS/39c79383-66bf-4f44-a6dd-14366e34e255/intel-dpcpp-cpp-compiler-2025.2.0.527_offline.sh"
ARG ONEAPI_FC_URL="https://registrationcenter-download.intel.com/akdlm/IRC_NAS/2c69ab6a-dfff-4d8f-ae1c-8368c79a1709/intel-fortran-compiler-2025.2.0.534_offline.sh"
RUN mkdir -p /container/logs && exec &> >(tee /container/logs/oneapi.log) \
    && ${PKG_INSTALL_CMD} procps \
    && echo "Installing Intel-OneAPI" \
    && echo "Intel OneAPI: https://www.intel.com/content/www/us/en/content-details/777700/intel-end-user-license-agreement-for-developer-tools-august-2024.html" >> /container/EULAs.txt \
    && ONEAPI_INSTALL_PATH="/container/intel-oneapi" \
    && mkdir -p /tmp/intel_installers && cd /tmp/intel_installers \
    && curl --retry 3 --retry-delay 5 -sO ${ONEAPI_CC_URL} \
    && curl --retry 3 --retry-delay 5 -sO ${ONEAPI_FC_URL} \
    && ls -ltrh \
    && for installer in  *${ONEAPI_VERSION}*.sh; do chmod +x ${installer} && ./${installer} -a -s --eula accept --install-dir ${ONEAPI_INSTALL_PATH} --ignore-errors; done \
    && cd ${ONEAPI_INSTALL_PATH} \
    && rm_paths="mpi debugger tbb conda_channel compiler/*/linux/lib/oclfpga /opt/intel" \
    && echo "Removing extra bloat: ${rm_paths}" > README.whered_stuff_go && cat README.whered_stuff_go \
    && rm -rf ${rm_paths} /tmp/intel_installers /var/intel \
    && echo -e "\n# Intel OneAPI compilers" >> /container/config_env.sh \
    && echo "export COMPILER_FAMILY=oneapi" >> /container/config_env.sh \
    && echo "source ${ONEAPI_INSTALL_PATH}/setvars.sh >/dev/null 2>&1" >> /container/config_env.sh \
    && source /container/config_env.sh \
    && echo "export oneapi_CC=$(which icx) && export CC=\${oneapi_CC}" >> /container/config_env.sh \
    && echo "export oneapi_CXX=$(which icpx) && export CXX=\${oneapi_CXX}" >> /container/config_env.sh \
    && echo "export oneapi_F77=$(which ifx) && export F77=\${oneapi_F77}" >> /container/config_env.sh \
    && echo "export oneapi_FC=$(which ifx) && export FC=\${oneapi_FC}" >> /container/config_env.sh \
    && echo ${LD_LIBRARY_PATH} | tr ':' '\n' | grep ${ONEAPI_INSTALL_PATH} >> /etc/ld.so.conf.d/intel-oneapi.conf \
    && ldconfig --verbose \
    && docker-clean
LABEL compiler="oneapi"
LABEL oneapi="${ONEAPI_VERSION}"



#-------------------------------------------------------------------------------
# AMD AOCC stage
FROM ${COMPILERS_PREREQ} AS aocc
#-------------------------------------------------------------------------------
# https://github.com/spack/spack/blob/develop/var/spack/repos/builtin/packages/aocc/package.py
ARG AOCC_VERSION="5.0.0"
ARG AOCC_URL="https://download.amd.com/developer/eula/aocc/aocc-5-0/aocc-compiler-5.0.0.tar"
RUN mkdir -p /container/logs && exec &> >(tee /container/logs/aocc.log) \
    && echo "Installing AMD AOCC-${AOCC_VERSION}" \
    && echo "AMD AOCC: https://www.amd.com/en/developer/aocc/aocc-compiler/eula.html" >> /container/EULAs.txt \
    && AOCC_INSTALL_PATH="/container/aocc/${AOCC_VERSION}" \
    && mkdir -p ${AOCC_INSTALL_PATH} && cd ${AOCC_INSTALL_PATH} \
    && curl --retry 3 --retry-delay 5 -sSL ${AOCC_URL} | tar Jx \
    && mv aocc-compiler-${AOCC_VERSION}/* . && rmdir aocc-compiler-${AOCC_VERSION} \
    && ls -ltrh \
    && ./install.sh && mv ../setenv_AOCC.sh . \
    && echo -e "\n# AMD AOCC compilers" >> /container/config_env.sh \
    && echo "export COMPILER_FAMILY=aocc" >> /container/config_env.sh \
    && echo "source ${AOCC_INSTALL_PATH}/setenv_AOCC.sh >/dev/null 2>&1" >> /container/config_env.sh \
    && source /container/config_env.sh \
    && echo "export aocc_CC=$(which clang) && export CC=\${aocc_CC}" >> /container/config_env.sh \
    && echo "export aocc_CXX=$(which clang++) && export CXX=\${aocc_CXX}" >> /container/config_env.sh \
    && echo "export aocc_F77=$(which flang) && export F77=\${aocc_F77}" >> /container/config_env.sh \
    && echo "export aocc_FC=$(which flang) && export FC=\${aocc_FC}" >> /container/config_env.sh \
    && echo ${LD_LIBRARY_PATH} | tr ':' '\n' | grep ${AOCC_INSTALL_PATH} >> /etc/ld.so.conf.d/aocc.conf \
    && ldconfig --verbose \
    && docker-clean
LABEL compiler="aocc"
LABEL aocc="${AOCC_VERSION}"



#-------------------------------------------------------------------------------
# NVHPC stage
FROM ${COMPILERS_PREREQ} AS nvhpc
#-------------------------------------------------------------------------------
#ARG NVHPC_VERSION="24.5"
#ARG NVHPC_URL="https://developer.download.nvidia.com/hpc-sdk/24.5/nvhpc_2024_245_Linux_x86_64_cuda_12.4.tar.gz"
#ARG NVHPC_VERSION="24.9"
#ARG NVHPC_URL="https://developer.download.nvidia.com/hpc-sdk/24.9/nvhpc_2024_249_Linux_x86_64_cuda_12.6.tar.gz"
ARG NVHPC_VERSION="25.1"
ARG NVHPC_URL="https://developer.download.nvidia.com/hpc-sdk/25.1/nvhpc_2025_251_Linux_x86_64_cuda_12.6.tar.gz"
ARG MARCH_FLAGS=""
RUN mkdir -p /container/logs && exec &> >(tee /container/logs/nvhpc.log) \
    && echo "Installing NVida HPC Toolkit ${NVHPC_VERSION}" \
    && echo "NVHPC: https://docs.nvidia.com/hpc-sdk/eula" >> /container/EULAs.txt \
    && cd /tmp \
    && echo "downloading ${NVHPC_URL}" \
    && curl --retry 3 --retry-delay 5 -sO ${NVHPC_URL} && tar zxf nvhpc*.tar.gz \
    && rm -f nvhpc*.tar.gz \
    && export NVHPC_SILENT="true" \
    && export NVHPC_INSTALL_DIR="/container/nvhpc" \
    && export NVHPC_INSTALL_TYPE="single" \
    && export MARCH_FLAGS=${MARCH_FLAGS} \
    && ./nvhpc_*/install \
    && echo -e "\n# NVHPC version ${NVHPC_VERSION}" >> /container/config_env.sh \
    && echo "export COMPILER_FAMILY=nvhpc" >> /container/config_env.sh \
    && echo "export NVARCH=$(uname -s)_$(uname -m)" >> /container/config_env.sh \
    && echo "export NVCOMPILERS=${NVHPC_INSTALL_DIR}" >> /container/config_env.sh \
    && echo "export MANPATH=\${MANPATH}:\${NVCOMPILERS}/\${NVARCH}/${NVHPC_VERSION}/compilers/man" >> /container/config_env.sh \
    && echo "export PATH=\${NVCOMPILERS}/\${NVARCH}/${NVHPC_VERSION}/compilers/bin:\$PATH" >> /container/config_env.sh \
    && echo "export MARCH_FLAGS=\"${MARCH_FLAGS}\"" >> /container/config_env.sh \
    && cd ${NVHPC_INSTALL_DIR}/$(uname -s)_$(uname -m)/${NVHPC_VERSION} \
    && rm_paths="comm_libs profilers math_libs" \
    && echo "Removing extra bloat: ${rm_paths}" > README.whered_stuff_go && (du -hs ${rm_paths} >> README.whered_stuff_go || true) && cat README.whered_stuff_go \
    && rm -rf ${rm_paths} \
    && echo "${NVHPC_INSTALL_DIR}/$(uname -s)_$(uname -m)/${NVHPC_VERSION}/compilers/lib" >> /etc/ld.so.conf.d/nvhpc.conf \
    && ldconfig --verbose \
    && source /container/config_env.sh \
    && echo "export nvhpc_CC=\"$(which nvc)\" && export CC=\"\${nvhpc_CC}\"" >> /container/config_env.sh \
    && echo "export nvhpc_CXX=\"$(which nvc++)\" && export CXX=\"\${nvhpc_CXX}\"" >> /container/config_env.sh \
    && echo "export nvhpc_F77=\"$(which nvfortran)\" && export F77=\"\${nvhpc_F77}\"" >> /container/config_env.sh \
    && echo "export nvhpc_FC=\"$(which nvfortran)\" && export FC=\"\${nvhpc_FC}\"" >> /container/config_env.sh \
    && echo "export CFLAGS=\"-fPIC ${MARCH_FLAGS}\"" >> /container/config_env.sh \
    && echo "export CXXFLAGS=\"-fPIC ${MARCH_FLAGS}\"" >> /container/config_env.sh \
    && echo "export F77FLAGS=\"-fPIC ${MARCH_FLAGS}\"" >> /container/config_env.sh \
    && echo "export FCFLAGS=\"-fPIC ${MARCH_FLAGS}\"" >> /container/config_env.sh \
    && docker-clean
# rm_paths="comm_libs cuda math_libs profilers" \
LABEL compiler="nvhpc"
LABEL nvhpc="${NVHPC_VERSION}"



#-------------------------------------------------------------------------------
# LLVM (clang) stage
FROM ${COMPILERS_PREREQ} AS clang
#-------------------------------------------------------------------------------
# ref. https://flang.llvm.org/docs/GettingStarted.html
# ref. https://github.com/llvm/llvm-project/blob/main/flang/docs/GettingStarted.md
ARG LLVM_VERSION="20.1.8"
RUN mkdir -p /container/logs && exec &> >(tee /container/logs/llvm.log) \
    && echo "Installing LLVM ${LLVM_VERSION}" \
    && source /etc/os-release \
    && id_tag="|${PLATFORM_ID}|${VERSION_CODENAME}|${ID}|" \
    && case "${id_tag}" in \
        *"almalinux"*) \
            dnf -y --enablerepo crb install \
                cmake lld zlib-devel libzstd-devel xz-devel bzip2-devel lz4-devel \
                libxml2-devel libedit-devel \
                ninja-build \
            ;; \
        *"leap|"*|*"tumbleweed|"*) \
            ${PKG_INSTALL_CMD} \
                cmake lld zlib-devel libzstd-devel xz-devel libbz2-devel liblz4-devel \
                libxml2-devel libedit-devel \
                ninja \
                python311 \
            ;; \
        *"|noble|"*) \
            ${PKG_INSTALL_CMD} \
                cmake lld zlib1g-dev libzstd-dev liblzma-dev libbz2-dev liblz4-dev \
                libxml2-dev libedit2-dev \
                ninja-build \
            ;; \
        *) \
            exit 1 \
            ;; \
       esac \
    && cd /tmp \
    && git clone --branch llvmorg-${LLVM_VERSION} --depth 1 https://github.com/llvm/llvm-project.git \
    && mkdir -p /tmp/BUILD_ALL && cd /tmp/BUILD_ALL \
    && export LLVM_INSTALL_PATH=/container/llvm/${LLVM_VERSION} \
    && cmake \
           -G Ninja \
           -DCMAKE_BUILD_TYPE=Release \
           -DCMAKE_INSTALL_PREFIX=${LLVM_INSTALL_PATH} \
           -DCMAKE_CXX_STANDARD=17 \
           -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
           -DCMAKE_CXX_LINK_FLAGS="-Wl,-rpath,$LD_LIBRARY_PATH" \
           -DFLANG_ENABLE_WERROR=ON \
           -DLLVM_ENABLE_ASSERTIONS=ON \
           -DLLVM_TARGETS_TO_BUILD=host \
           -DLLVM_LIT_ARGS=-v \
           -DLLVM_ENABLE_PROJECTS="clang;mlir;flang;openmp;lld" \
           ../llvm-project/llvm \
    && (ninja -C . -j ${MAKE_J_PROCS:-$(nproc)} || ninja -C . -j 2 || ninja -C . -j 2 || ninja -C . -j 1) && ninja -C . install \
    && echo -e "\n# LLVM clang compilers" >> /container/config_env.sh \
    && echo "export COMPILER_FAMILY=clang" >> /container/config_env.sh \
    && echo "export LLVM_VERSION=${LLVM_VERSION}"  >> /container/config_env.sh \
    && echo "export PATH=${LLVM_INSTALL_PATH}/bin:\${PATH}" >> /container/config_env.sh \
    && echo "export LD_LIBRARY_PATH=${LLVM_INSTALL_PATH}/lib64:${LLVM_INSTALL_PATH}/lib:\${LD_LIBRARY_PATH}" >> /container/config_env.sh \
    && source /container/config_env.sh \
    && echo "export clang_CC=$(which clang) && export CC=\${clang_CC}" >> /container/config_env.sh \
    && echo "export clang_CXX=$(which clang++) && export CXX=\${clang_CXX}" >> /container/config_env.sh \
    && echo "export clang_F77=$(which flang) && export F77=\${clang_F77}" >> /container/config_env.sh \
    && echo "export clang_FC=$(which flang) && export FC=\${clang_FC}" >> /container/config_env.sh \
    && echo "${LLVM_INSTALL_PATH}/lib" >> /etc/ld.so.conf.d/llvm.conf \
    && ls -d ${LLVM_INSTALL_PATH}/lib/$(uname -m)-*  >> /etc/ld.so.conf.d/llvm.conf \
    && ldconfig --verbose \
    && docker-clean
LABEL compiler="clang"
LABEL clang="${LLVM_VERSION}"



#-------------------------------------------------------------------------------
FROM ${COMPILER_FAMILY} AS compilers
RUN echo "Settiing ${COMPILER_FAMILY} compiler layer"
#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------
# Cuda stages
FROM ${CUDA_PREREQ} AS cuda
#-------------------------------------------------------------------------------
#ARG CUDA_VERSION="12.6"
#ARG CUDA_INSTALLER_URL="https://developer.download.nvidia.com/compute/cuda/12.6.2/local_installers/cuda_12.6.2_560.35.03_linux.run"
ARG CUDA_VERSION="12.9"
ARG CUDA_INSTALLER_URL="https://developer.download.nvidia.com/compute/cuda/12.9.1/local_installers/cuda_12.9.1_575.57.08_linux.run"
ARG CUDA_HOME="/container/cuda/${CUDA_VERSION}"
ENV CUDA_HOME="${CUDA_HOME}"
RUN mkdir -p /container/logs && exec &> >(tee /container/logs/cuda.log) \
    && cd /tmp \
    && env \
    && echo "Cuda v${CUDA_VERSION} - runfile installer" \
    && echo "CUDA: https://docs.nvidia.com/cuda/eula/index.html" >> /container/EULAs.txt \
    && mkdir -p ${CUDA_HOME} \
    && curl --retry 3 --retry-delay 5 -sO ${CUDA_INSTALLER_URL} \
    && bash ./cuda_*_linux*.run \
            --silent \
            --toolkit \
            --toolkitpath=${CUDA_HOME} \
            --no-man-page \
    && cd ${CUDA_HOME} \
    && rm_paths="nsight-*/ extras/ bin/nsys* bin/nsight* libnvvp/" \
    && echo "Removing extra bloat: ${rm_paths}" > README.whered_stuff_go && (du -hs ${rm_paths} >> README.whered_stuff_go || true) && cat README.whered_stuff_go \
    && rm -rf ${rm_paths} \
    && echo -e "\n# CUDA ${CUDA_VERSION}" >> /container/config_env.sh \
    && echo "export CUDA_HOME=${CUDA_HOME}" >> /container/config_env.sh \
    && echo "export PATH=${CUDA_HOME}/bin:\${PATH}" >> /container/config_env.sh \
    && echo "export CPATH=${CUDA_HOME}/include:\${CPATH}" >> /container/config_env.sh \
    && echo "export CUDA_STUBDIR=${CUDA_HOME}/targets/$(uname -m)-linux/lib/stubs" >> /container/config_env.sh \
    && echo "export LIBRARY_PATH=${CUDA_HOME}/lib64:\${CUDA_STUBDIR}:\${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "export NVCC_PREPEND_FLAGS=-allow-unsupported-compiler" >> /container/config_env.sh \
    && echo "$(find /container/cuda -type d -name stubs)" >> /etc/ld.so.conf.d/cuda*.conf \
    && ldconfig --verbose \
    && docker-clean
#     && find -name "*_static.a" | xargs rm -f \
ARG TOGGLE_WITH_CUDA="--with-cuda=${CUDA_HOME}"
LABEL cuda="${CUDA_VERSION}"



#-------------------------------------------------------------------------------
# ROCm stages
FROM ${ROCM_PREREQ} AS rocm
#-------------------------------------------------------------------------------
ARG ROCM_VERSION="6.2.3"
ARG ROCM_HOME="/opt/rocm-${ROCM_VERSION}"
ENV ROCM_HOME="${ROCM_HOME}"
RUN mkdir -p /container/logs && exec &> >(tee /container/logs/rocm.log) \
    && echo "Rocm - amdgpu-install installer (https://rocm.docs.amd.com/projects/install-on-linux/en/latest/install/amdgpu-install.html)" \
    && echo "ROCm: https://rocm.docs.amd.com/en/latest/about/license.html" >> /container/EULAs.txt \
    && source /etc/os-release \
    && cd /tmp \
    && env \
    && mkdir -p ${ROCM_HOME:-/container/rocm} \
    && case "|${PLATFORM_ID}|${VERSION_CODENAME}|${ID}|" in \
        *"|platform:el8|"*) \
            ${PKG_INSTALL_CMD} https://repo.radeon.com/amdgpu/${ROCM_VERSION}/el/8.10/main/x86_64/amdgpu-install-6.2.60203-2044426.el8.noarch.rpm \
            ;; \
        *"|platform:el9|"*) \
            ${PKG_INSTALL_CMD} https://repo.radeon.com/amdgpu/${ROCM_VERSION}/el/9.4/main/x86_64/amdgpu-install-6.2.60203-2044426.el9.noarch.rpm \
            ;; \
        *"|leap|"*) \
            echo -e "gpgcheck = off\nrepo_gpgcheck = off\npkg_gpgcheck = off" >> /etc/zypp/zypp.conf \
            && zypper --gpg-auto-import-keys --no-gpg-checks --non-interactive \install https://repo.radeon.com/amdgpu/${ROCM_VERSION}/sle/15.6/main/x86_64/amdgpu-install-6.2.60203-2044426.noarch.rpm \
            && zypper --gpg-auto-import-keys --no-gpg-checks --non-interactive update \
            ;; \
        *"|noble|"*) \
            curl --retry 3 --retry-delay 5 -sO https://repo.radeon.com/amdgpu-install/${ROCM_VERSION}/ubuntu/noble/amdgpu-install_6.2.60203-1_all.deb \
            && ${PKG_INSTALL_CMD} ./amdgpu-install*.deb \
            ;; \
        *) \
            exit 1 \
            ;; \
       esac \
    && amdgpu-install --help \
    && amdgpu-install --list-usecase \
    && amdgpu-install -y --usecase=hiplibsdk --no-dkms --accept-eula --dryrun \
    && amdgpu-install -y --usecase=hiplibsdk --no-dkms --accept-eula \
    && echo -e "\n# ROCM ${ROCM_VERSION}" >> /container/config_env.sh \
    && echo "export ROCM_VERSION=${ROCM_VERSION}" >> /container/config_env.sh \
    && echo "export PATH=${ROCM_HOME}/bin:\${PATH}" >> /container/config_env.sh \
    && echo "export CPATH=${ROCM_HOME}/include:\${CPATH}" >> /container/config_env.sh \
    && echo "export LIBRARY_PATH=${ROCM_HOME}/lib:\${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "${ROCM_HOME}/lib" >> /etc/ld.so.conf.d/rocm-${ROCM_VERSION}.conf \
    && ldconfig --verbose \
    && docker-clean
# amdgpu-install -y --usecase=rocmdevtools,hiplibsdk --no-dkms --accept-eula --dryrun
ARG TOGGLE_WITH_ROCM="--with-rocm=${ROCM_HOME} --with-hip=${ROCM_HOME}"
LABEL rocm="${ROCM_VERSION}"



################################################################################
# Part 3: MPIs
################################################################################

#-------------------------------------------------------------------------------
# MPICH variants
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# MPICH 3.4.x; compatible with Derecho
FROM ${MPI_PREREQ} AS mpich3
# Notes:
#   NVHPC:
#    mpich-3.4.3 does not build with nvhpc's C/C++ compilers, so we will use the system gccs to
#    build mpich, but then set the MPICH_{CC,CXX} vars later for the downstream wrappers.
#    mpich-3.4.3 and nvfortran misunderstand each other regarding real*16, avoid false positive.
#    so we take the rather drastic step of modyfying configure.ac to prevent building the f08 interface,
#    no matter what configure *thinks* it finds...
#   CLANG:
#    ditto f08 interface
#   GCC:
#    modern versions require -fallow-argument-mismatch. Setting FFLAGS and FCFLAGS at configure time
#    will use these flags for both compiling the library and within the resulting wrappers
#    (ref. https://www.mpich.org/static/downloads/3.4.3/mpich-3.4.3-README.txt)
#  -lmpicxx:
#    We can't get mpicxx without -lmpicxx for mpich-v3.x, yet the -lmpicxx bindings are worthless
#    and do not exist on our Cray-EX cray-mpich.  So at minimum, prefent them from being linked,
#    since we would not then be able to override them. - final sed step
#-------------------------------------------------------------------------------
ARG MPICH_VERSION="3.4.3"
RUN mkdir -p /container/logs && exec &> >(tee /container/logs/mpich.log) \
    && echo "building MPICH-${MPICH_VERSION}" \
    && env \
    && echo "Installing additional dependencies" \
    && (${PKG_INSTALL_CMD} glibc-devel file pkgconf patch \
            || ${PKG_INSTALL_CMD} libc-dev linux-libc-dev libc6-dev file pkg-config patch \
            || (apt-get update && ${PKG_INSTALL_CMD} libc-dev linux-libc-dev libc6-dev file pkg-config patch) \
            || false) \
    && MPICH_INSTALL_PATH="/container/mpich/${MPICH_VERSION}" \
    && cd /tmp && curl --retry 3 --retry-delay 5 -sSL https://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz | tar xz \
    && cd ./mpich-${MPICH_VERSION} \
    && mkdir -p /container/logs/ \
    && case "${COMPILER_FAMILY}" in \
        "gcc") \
            export FFLAGS="-fallow-argument-mismatch ${FFLAGS}" && export FCFLAGS="-fallow-argument-mismatch ${FCFLAGS}" \
            ;; \
        "nvhpc") \
            sed -i 's/f08_works=yes/f08_works=no/g' configure.ac \
            && ./autogen.sh \
            && export CC="/usr/bin/gcc" \
            && export CXX="/usr/bin/g++" \
            && export CXXFLAGS="-fPIC ${MARCH_FLAGS}" \
            && export CFLAGS="-fPIC ${MARCH_FLAGS}" \
            && export FFLAGS="-fPIC ${MARCH_FLAGS}" \
            && export FCFLAGS="-fPIC ${MARCH_FLAGS}" \
            ;; \
        "clang") \
            sed -i 's/f08_works=yes/f08_works=no/g' configure.ac \
            && ./autogen.sh \
            ;; \
       esac \
    && ./configure --help \
    && (./configure \
           --prefix=${MPICH_INSTALL_PATH} \
           --enable-threads=multiple \
           --with-device=ch4:ofi \
           --enable-silent-rules \
           --disable-static --enable-shared \
           --enable-fortran \
           ${TOGGLE_WITH_CUDA} \
           ${TOGGLE_WITH_ROCM} \
           --disable-dependency-tracking | tee /container/logs/mpich-configure.log \
            || cat config.log) \
    && make --no-print-directory --jobs ${MAKE_J_PROCS:-$(nproc)} V=0 | tee /container/logs/mpich-build.log \
    && make --no-print-directory install | tee /container/logs/mpich-install.log \
    && echo -e "\n# MPICH ${MPICH_VERSION}" >> /container/config_env.sh \
    && echo "export MPI_FAMILY=mpich" >> /container/config_env.sh \
    && echo "export MPI_ROOT=${MPICH_INSTALL_PATH}"  >> /container/config_env.sh \
    && echo "export MPICH_VERSION=${MPICH_VERSION}" >> /container/config_env.sh \
    && echo "export PATH=${MPICH_INSTALL_PATH}/bin:\${PATH}" >> /container/config_env.sh \
    && echo "${MPICH_INSTALL_PATH}/lib" >> /etc/ld.so.conf.d/mpich-${MPICH_VERSION}.conf \
    && ldconfig --verbose \
    && source /container/config_env.sh \
    && ( which mpicxx || { echo "no mpicxx found, build fail?!"; exit 1; } ) \
    && sed -i 's/cxxlibs="-lmpicxx"/cxxlibs= #"-lmpicxx"/g' $(which mpicxx) \
    && case "${COMPILER_FAMILY}" in \
        "nvhpc") \
            echo "# MPICH+nvhpc: built with nvfortran/gcc/g++, but revert to nvhpc C/C++ compilers in the mpicc/mpicxx wrappers" >> /container/config_env.sh \
            && echo "export MPICH_CC=${nvhpc_CC}" >> /container/config_env.sh \
            && echo "export MPICH_CXX=${nvhpc_CXX}" >> /container/config_env.sh \
            ;; \
       esac \
    && docker-clean
LABEL mpi="mpich"
LABEL mpich="${MPICH_VERSION}"



#-------------------------------------------------------------------------------
# MPICH
FROM ${MPI_PREREQ} AS mpich
#-------------------------------------------------------------------------------
ARG MPICH_VERSION="4.3.1"
#ARG MPICH_DEVICE="ch4:ofi,ucx"
ARG MPICH_DEVICE="ch4:ucx"
RUN mkdir -p /container/logs && exec &> >(tee /container/logs/mpich.log) \
    && echo "building MPICH-${MPICH_VERSION}" \
    && env \
    && echo "Installing additional dependencies" \
    && (${PKG_INSTALL_CMD} glibc-devel file pkgconf \
            || ${PKG_INSTALL_CMD} libc-dev linux-libc-dev libc6-dev file pkg-config \
            || (apt-get update && ${PKG_INSTALL_CMD} libc-dev linux-libc-dev libc6-dev file pkg-config) \
            || false) \
    && MPICH_INSTALL_PATH="/container/mpich/${MPICH_VERSION}" \
    && cd /tmp && curl --retry 3 --retry-delay 5 -sSL https://www.mpich.org/static/downloads/${MPICH_VERSION}/mpich-${MPICH_VERSION}.tar.gz | tar xz \
    && cd ./mpich-${MPICH_VERSION} \
    && mkdir -p /container/logs/ \
    && case "${COMPILER_FAMILY}:${GCC_VERSION}" in \
        "gcc:15."*) \
            export CFLAGS="-std=gnu17 -Wno-incompatible-pointer-types ${CFLAGS}" \
            ;; \
       esac \
    && ./configure --help \
    && (./configure \
           --prefix=${MPICH_INSTALL_PATH} \
           --enable-threads=multiple \
           --with-device=${MPICH_DEVICE} \
           --enable-silent-rules \
           --disable-static --enable-shared \
           --disable-cxx \
           ${TOGGLE_WITH_CUDA} \
           ${TOGGLE_WITH_ROCM} \
           --disable-dependency-tracking | tee /container/logs/mpich-configure.log \
            || cat config.log) \
    && make --no-print-directory --jobs ${MAKE_J_PROCS:-$(nproc)} V=0 | tee /container/logs/mpich-build.log \
    && make --no-print-directory install | tee /container/logs/mpich-install.log \
    && echo -e "\n# MPICH ${MPICH_VERSION}" >> /container/config_env.sh \
    && echo "export MPI_FAMILY=mpich" >> /container/config_env.sh \
    && echo "export MPI_ROOT=${MPICH_INSTALL_PATH}" >> /container/config_env.sh \
    && echo "export MPICH_VERSION=${MPICH_VERSION}" >> /container/config_env.sh \
    && echo "export PATH=${MPICH_INSTALL_PATH}/bin:\${PATH}" >> /container/config_env.sh \
    && echo "${MPICH_INSTALL_PATH}/lib" >> /etc/ld.so.conf.d/mpich-${MPICH_VERSION}.conf \
    && ldconfig --verbose \
    && source /container/config_env.sh \
    && ( which mpicxx || { echo "no mpicxx found, build fail?!"; exit 1; } ) \
    && docker-clean
LABEL mpi="mpich"
LABEL mpich="${MPICH_VERSION}"



#-------------------------------------------------------------------------------
# OpenMPI variants
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# OpenMPI
FROM ${MPI_PREREQ} AS openmpi
# Notes:
#   AOCC:
#     problem with half-precision floats; revisit with newer versions (>5.0.8)
#     https://github.com/open-mpi/ompi/issues/13181
#-------------------------------------------------------------------------------
ARG OPENMPI_VERSION="5.0.8"
ENV OPENMPI_VERSION="${OPENMPI_VERSION}"
RUN mkdir -p /container/logs && exec &> >(tee /container/logs/openmpi.log) \
    && echo "building OpenMPI-${OPENMPI_VERSION}" \
    && echo "Installing additional compression libraries for OpenMPI" \
    && (${PKG_INSTALL_CMD} zlib-devel libzstd-devel xz-devel bzip2-devel lz4-devel \
            || ${PKG_INSTALL_CMD} zlib-devel libzstd-devel xz-devel libbz2-devel liblz4-devel \
            || (apt-get update && ${PKG_INSTALL_CMD} zlib1g-dev libzstd-dev liblzma-dev libbz2-dev liblz4-dev) \
            || false) \
    && env \
    && OPENMPI_INSTALL_PATH="/container/openmpi/${OPENMPI_VERSION}" \
    && cd /tmp && curl --retry 3 --retry-delay 5 -sSL https://download.open-mpi.org/release/open-mpi/v$(echo ${OPENMPI_VERSION} | cut -d . -f -2)/openmpi-${OPENMPI_VERSION}.tar.bz2 | tar xj \
    && cd ./openmpi-${OPENMPI_VERSION} \
    && mkdir -p /container/logs/ \
    && case "${COMPILER_FAMILY}" in \
        "aocc") extra_config_args="--disable-alt-short-float" ;; \
       esac \
    && ./configure --help \
    && (./configure \
           --prefix=${OPENMPI_INSTALL_PATH} ${extra_config_args} \
           ${TOGGLE_WITH_CUDA} \
           ${TOGGLE_WITH_ROCM} \
           --disable-static --enable-shared \
           --disable-dependency-tracking | tee /container/logs/openmpi-configure.log \
            || cat config.log) \
    && make --no-print-directory --jobs ${MAKE_J_PROCS:-$(nproc)} V=0 | tee /container/logs/openmpi-build.log \
    && make --no-print-directory install | tee /container/logs/openmpi-install.log \
    && cd ${OPENMPI_INSTALL_PATH} \
    && rm_paths="share/doc/ share/man/" \
    && echo "Removing extra bloat: ${rm_paths}" > README.whered_stuff_go && (du -hs ${rm_paths} >> README.whered_stuff_go || true) && cat README.whered_stuff_go \
    && rm -rf ${rm_paths} \
    && echo -e "\n# OPENMPI ${OPENMPI_VERSION}" >> /container/config_env.sh \
    && echo "export MPI_FAMILY=openmpi" >> /container/config_env.sh \
    && echo "export MPI_ROOT=${OPENMPI_INSTALL_PATH}" >> /container/config_env.sh \
    && echo "export OPENMPI_VERSION=${OPENMPI_VERSION}" >> /container/config_env.sh \
    && echo "export PATH=${OPENMPI_INSTALL_PATH}/bin:\${PATH}" >> /container/config_env.sh \
    && echo "${OPENMPI_INSTALL_PATH}/lib" >> /etc/ld.so.conf.d/openmpi-${OPENMPI_VERSION}.conf \
    && ldconfig --verbose \
    && source /container/config_env.sh \
    && ( which mpicxx || { echo "no mpicxx found, build fail?!"; exit 1; } ) \
    && ompi_info --all --parseable \
    && ompi_info --parsable --all | grep mpi_built_with_cuda_support:value \
    && docker-clean
LABEL mpi="openmpi"
LABEL openmpi="${OPENMPI_VERSION}"



#-------------------------------------------------------------------------------
FROM ${MPI_FAMILY} AS mpi
RUN echo "Settiing ${MPI_FAMILY} MPI layer" \
    && echo "export CXX=$(which mpicxx)" >> /container/config_env.sh \
    && echo "export CC=$(which mpicc)" >> /container/config_env.sh \
    && echo "export FC=$(which mpifort)" >> /container/config_env.sh \
    && echo "export F77=$(which mpif77)" >> /container/config_env.sh \
    && echo "export MPICXX=$(which mpicxx)" >> /container/config_env.sh \
    && echo "export MPICC=$(which mpicc)" >> /container/config_env.sh \
    && echo "export MPIFC=$(which mpifort)" >> /container/config_env.sh \
    && echo "export MPIF77=$(which mpif77)" >> /container/config_env.sh \
    && docker-clean
ARG TOGGLE_ENABLE_PARALLEL="--enable-parallel"
ENV CC="mpicc"
ENV CXX="mpicxx"
ENV F77="mpif77"
ENV FC="mpifort"
#-------------------------------------------------------------------------------



################################################################################
# Part 4: Libraries (that may or may not require MPI).
################################################################################

#-------------------------------------------------------------------------------
# HDF5 & NetCDF
FROM ${IOLIBS_PREREQ} AS iolibs
# (ref: https://github.com/Unidata/netcdf-fortran/issues/309 for aocc libtool fix)
#-------------------------------------------------------------------------------
ARG SZIP_VERSION="2.1.1"
ARG BLOSC_VERSION="1.21.5"
ARG HDF5_VERSION="1.14.6"
ARG NETCDF_C_VERSION="4.9.3"
ARG NETCDF_FORTRAN_VERSION="4.6.2"
RUN mkdir -p /container/logs && exec &> >(tee /container/logs/iolibs.log) \
    && echo "building IO libraries" \
    && echo "Installing additional compression libraries" \
    && (${PKG_INSTALL_CMD} zlib-devel libzstd-devel xz-devel bzip2-devel lz4-devel cmake \
            || ${PKG_INSTALL_CMD} zlib-devel libzstd-devel xz-devel libbz2-devel liblz4-devel cmake \
            || (apt-get update && ${PKG_INSTALL_CMD} zlib1g-dev libzstd-dev liblzma-dev libbz2-dev liblz4-dev cmake) \
            || false) \
    && echo "building libszip-${SZIP_VERSION}" \
    && env \
    && SZIP_INSTALL_PATH="/container/szip/${SZIP_VERSION}" \
    && cd /tmp && curl --retry 3 --retry-delay 5 -sSL https://support.hdfgroup.org/ftp/lib-external/szip/${SZIP_VERSION}/src/szip-${SZIP_VERSION}.tar.gz | tar zx \
    && cd ./szip-${SZIP_VERSION} \
    && ./configure --help \
    && (./configure \
            --prefix=${SZIP_INSTALL_PATH} \
            --disable-static --enable-shared \
            --disable-dependency-tracking \
            || cat config.log) \
    && make --no-print-directory --jobs ${MAKE_J_PROCS:-$(nproc)} V=0 \
    && make --no-print-directory install-strip \
    && echo "#include <stddef.h>" >> ${SZIP_INSTALL_PATH}/include/ricehdf.h \
    && echo -e "\n# SZIP ${SZIP_VERSION}" >> /container/config_env.sh \
    && echo "export SZIP_VERSION=${SZIP_VERSION}" >> /container/config_env.sh \
    && echo "export PATH=${SZIP_INSTALL_PATH}/bin:\${PATH}" >> /container/config_env.sh \
    && echo "export CPATH=${SZIP_INSTALL_PATH}/include:\${CPATH}" >> /container/config_env.sh \
    && echo "export LIBRARY_PATH=${SZIP_INSTALL_PATH}/lib:\${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "${SZIP_INSTALL_PATH}/lib" >> /etc/ld.so.conf.d/szip.conf \
    && ldconfig --verbose \
    && source /container/config_env.sh \
    && echo "building libblosc-${BLOSC_VERSION}" \
    && env \
    && BLOSC_INSTALL_PATH="/container/c-blosc/${BLOSC_VERSION}" \
    && cd /tmp && curl --retry 3 --retry-delay 5 -sSL https://github.com/Blosc/c-blosc/archive/v${BLOSC_VERSION}.tar.gz | tar zx \
    && cd ./c-blosc-${BLOSC_VERSION} \
    && case "${COMPILER_FAMILY}:${GCC_VERSION}" in \
        "gcc:15."*) \
            export CFLAGS="-std=gnu17 ${CFLAGS}" \
            ;; \
       esac \
    && cmake \
           -DCMAKE_INSTALL_PREFIX=${BLOSC_INSTALL_PATH} \
           -DCMAKE_INSTALL_DO_STRIP=1 \
           -DPREFER_EXTERNAL_ZLIB=ON \
           -DPREFER_EXTERNAL_ZSTD=ON \
           -DPREFER_EXTERNAL_LZ4=ON \
    && make --no-print-directory --jobs ${MAKE_J_PROCS:-$(nproc)} V=0 \
    && make --no-print-directory install \
    && echo -e "\n# BLOSC ${BLOSC_VERSION}" >> /container/config_env.sh \
    && echo "export BLOSC_VERSION=${BLOSC_VERSION}" >> /container/config_env.sh \
    && echo "export PATH=${BLOSC_INSTALL_PATH}/bin:\${PATH}" >> /container/config_env.sh \
    && echo "export CPATH=${BLOSC_INSTALL_PATH}/include:\${CPATH}" >> /container/config_env.sh \
    && echo "export LIBRARY_PATH=${BLOSC_INSTALL_PATH}/lib64:\${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "${BLOSC_INSTALL_PATH}/lib64" >> /etc/ld.so.conf.d/blosc.conf \
    && ldconfig --verbose \
    && source /container/config_env.sh \
    && echo "building HDF5-${HDF5_VERSION}" \
    && env \
    && HDF5_INSTALL_PATH="/container/hdf5/${HDF5_VERSION}" \
    && cd /tmp && curl --retry 3 --retry-delay 5 -sSL https://github.com/HDFGroup/hdf5/releases/download/hdf5_${HDF5_VERSION}/hdf5-${HDF5_VERSION}.tar.gz | tar zx \
    && cd ./hdf5-${HDF5_VERSION} \
    && case "${COMPILER_FAMILY}" in \
        "nvhpc"|"aocc"|"clang") \
            extra_args="--disable-nonstandard-feature-float16 --disable-tests" \
            ;; \
        *) \
            unset extra_args \
            ;; \
       esac \
    && ./configure --help \
    && (./configure \
            --prefix=${HDF5_INSTALL_PATH} \
            --disable-static --enable-shared \
            --with-default-plugindir \
            --enable-fortran \
            --disable-cxx \
            --enable-hl ${extra_args} \
            ${TOGGLE_ENABLE_PARALLEL} \
            --disable-dependency-tracking \
            || cat config.log) \
    && case "${COMPILER_FAMILY}" in \
        "clang") sed -i -e 's/wl=""/wl="-Wl,"/g' libtool ;; \
       esac \
    && make --no-print-directory --jobs ${MAKE_J_PROCS:-$(nproc)} V=0 \
    && make --no-print-directory install-strip \
    && make --silent --no-print-directory installcheck \
    && echo -e "\n# HDF5 ${HDF5_VERSION}" >> /container/config_env.sh \
    && echo "export HDF5_VERSION=${HDF5_VERSION}" >> /container/config_env.sh \
    && echo "export PATH=${HDF5_INSTALL_PATH}/bin:\${PATH}" >> /container/config_env.sh \
    && echo "export CPATH=${HDF5_INSTALL_PATH}/include:\${CPATH}" >> /container/config_env.sh \
    && echo "export LIBRARY_PATH=${HDF5_INSTALL_PATH}/lib:\${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "${HDF5_INSTALL_PATH}/lib" >> /etc/ld.so.conf.d/hdf5.conf \
    && ldconfig --verbose \
    && source /container/config_env.sh \
    && echo "Installing additional NetCDF dependencies" \
    && (${PKG_INSTALL_CMD} libxml2-devel curl-devel \
            || ${PKG_INSTALL_CMD} libxml2-dev libcurl4-openssl-dev \
            || false) \
    && echo "building NETCDF-${NETCDF_C_VERSION}" \
    && NETCDF_INSTALL_PATH="/container/netcdf" \
    && HDF5_PLUGIN_PATH="${NETCDF_INSTALL_PATH}/lib/plugins" \
    && cd /tmp \
    && curl --retry 3 --retry-delay 5 -sSL https://github.com/Unidata/netcdf-c/archive/v${NETCDF_C_VERSION}.tar.gz | tar zx \
    && curl --retry 3 --retry-delay 5 -sSL https://github.com/Unidata/netcdf-fortran/archive/v${NETCDF_FORTRAN_VERSION}.tar.gz | tar zx \
    && cd /tmp/netcdf-c-${NETCDF_C_VERSION} \
    && ./configure --help \
    && (./configure \
            --prefix=${NETCDF_INSTALL_PATH} \
            --disable-static --enable-shared \
            --enable-plugins \
            --with-plugin-dir=${HDF5_PLUGIN_PATH} \
            --disable-dependency-tracking \
            || cat config.log) \
    && make --no-print-directory --jobs ${MAKE_J_PROCS:-$(nproc)} V=0 \
    && make --no-print-directory install-strip \
    && make --silent --no-print-directory installcheck \
    && echo -e "\n# NETCDF libraries" >> /container/config_env.sh \
    && echo "export NETCDF=${NETCDF_INSTALL_PATH}" >> /container/config_env.sh \
    && echo "export NETCDF_C_VERSION=${NETCDF_C_VERSION}" >> /container/config_env.sh \
    && echo "export NETCDF_FORTRAN_VERSION=${NETCDF_FORTRAN_VERSION}" >> /container/config_env.sh \
    && echo "export PATH=${NETCDF_INSTALL_PATH}/bin:\${PATH}" >> /container/config_env.sh \
    && echo "export CPATH=${NETCDF_INSTALL_PATH}/include:\${CPATH}" >> /container/config_env.sh \
    && echo "export LIBRARY_PATH=${NETCDF_INSTALL_PATH}/lib:${HDF5_PLUGIN_PATH}\${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "export HDF5_PLUGIN_PATH=${HDF5_PLUGIN_PATH}" >> /container/config_env.sh \
    && echo "${NETCDF_INSTALL_PATH}/lib" >> /etc/ld.so.conf.d/netcdf.conf \
    && echo "${HDF5_PLUGIN_PATH}" >> /etc/ld.so.conf.d/netcdf.conf \
    && ldconfig --verbose \
    && source /container/config_env.sh \
    && cd /tmp/netcdf-fortran-${NETCDF_FORTRAN_VERSION} \
    && ./configure --help \
    && (./configure \
            --prefix=${NETCDF_INSTALL_PATH} \
            CFLAGS="${CFLAGS}" \
            CXXFLAGS="${CXXFLAGS}" \
            FCFLAGS="${FCFLAGS}" \
            --disable-static --enable-shared \
            --enable-zstandard-plugin \
            --disable-dependency-tracking \
            || cat config.log) \
    && case "${COMPILER_FAMILY}" in \
        "aocc"|"clang") sed -i -e 's/wl=""/wl="-Wl,"/g' libtool ;; \
       esac \
    && make --no-print-directory --jobs ${MAKE_J_PROCS:-$(nproc)} V=0 \
    && make --no-print-directory install-strip \
    && make --silent --no-print-directory installcheck \
    && ldconfig --verbose \
    && (h5pcc -showconfig || h5cc -showconfig) \
    && (nc-config --all && nf-config --all) \
    && docker-clean
LABEL hdf5="${HDF5_VERSION}"
LABEL netcdf-c="${NETCDF_C_VERSION}"
LABEL netcdf-fortran="${NETCDF_FORTRAN_VERSION}"



#-------------------------------------------------------------------------------
# PNetCDF & ParalleIO
FROM ${MPIIOLIBS_PREREQ} AS mpi-iolibs
#-------------------------------------------------------------------------------
ARG PNETCDF_VERSION="1.14.0"
ARG PIO_VERSION="2.6.6"
ARG PIO_TAG="pio2_6_6"
RUN mkdir -p /container/logs && exec &> >(tee /container/logs/mpi-iolibs.log) \
    && echo "building parallel IO libraries" \
    && echo "building pnetcdf-${PNETCDF_VERSION}" \
    && env \
    && PNETCDF_INSTALL_PATH="/container/pnetcdf/${PNETCDF_VERSION}" \
    && cd /tmp && curl --retry 3 --retry-delay 5 -sSL https://parallel-netcdf.github.io/Release/pnetcdf-${PNETCDF_VERSION}.tar.gz | tar zx \
    && cd ./pnetcdf-${PNETCDF_VERSION} \
    && case "${COMPILER_FAMILY}:${GCC_VERSION}" in \
        "gcc:15."*) \
            export CFLAGS="-std=gnu17 ${CFLAGS}" \
            ;; \
       esac \
    && ./configure --help \
    && (./configure \
            --prefix=${PNETCDF_INSTALL_PATH} \
            FCFLAGS="${FCFLAGS}" FFLAGS="${FCFLAGS}" \
            --disable-static --enable-shared \
            --disable-dependency-tracking \
            || cat config.log) \
    && make --no-print-directory --jobs ${MAKE_J_PROCS:-$(nproc)} V=0 \
    && make --no-print-directory install-strip \
    && echo -e "\n# PNETCDF ${PNETCDF_VERSION}" >> /container/config_env.sh \
    && echo "export PNETCDF=${PNETCDF_INSTALL_PATH}" >> /container/config_env.sh \
    && echo "export PNETCDF_VERSION=${PNETCDF_VERSION}" >> /container/config_env.sh \
    && echo "export PATH=${PNETCDF_INSTALL_PATH}/bin:\${PATH}" >> /container/config_env.sh \
    && echo "export CPATH=${PNETCDF_INSTALL_PATH}/include:\${CPATH}" >> /container/config_env.sh \
    && echo "export LIBRARY_PATH=${PNETCDF_INSTALL_PATH}/lib:\${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "${PNETCDF_INSTALL_PATH}/lib" >> /etc/ld.so.conf.d/pnetcdf.conf \
    && ldconfig --verbose \
    && source /container/config_env.sh \
    && echo "building ParallelIO-${PIO_VERSION}" \
    && case "${COMPILER_FAMILY}" in \
        "nvhpc"|"aocc"|"clang") export FCFLAGS="${FCFLAGS} -I/container/netcdf/include" ;; \
        *) ;; \
       esac \
    && env \
    && PIO_INSTALL_PATH="/container/parallelio/${PIO_VERSION}" \
    && cd /tmp && curl --retry 3 --retry-delay 5 -sSL https://github.com/NCAR/ParallelIO/archive/refs/tags/${PIO_TAG}.tar.gz | tar zx \
    && cd ./*${PIO_TAG}/ \
    && autoreconf -iv --force \
    && ./configure --help \
    && (./configure \
            --prefix=${PIO_INSTALL_PATH} \
            FCFLAGS="${FCFLAGS}" F77FLAGS="${FCFLAGS}" \
            --enable-fortran \
            --disable-static --enable-shared \
            --disable-dependency-tracking \
            || cat config.log) \
    && case "${COMPILER_FAMILY}" in \
        "aocc"|"clang") sed -i -e 's/wl=""/wl="-Wl,"/g' libtool ;; \
       esac \
    && make --no-print-directory --jobs ${MAKE_J_PROCS:-$(nproc)} V=0 \
    && make --no-print-directory install-strip \
    && echo -e "\n# PIO ${PIO_VERSION}" >> /container/config_env.sh \
    && echo "export PIO=${PIO_INSTALL_PATH}" >> /container/config_env.sh \
    && echo "export PIO_VERSION=${PIO_VERSION}" >> /container/config_env.sh \
    && echo "export PATH=${PIO_INSTALL_PATH}/bin:\${PATH}" >> /container/config_env.sh \
    && echo "export CPATH=${PIO_INSTALL_PATH}/include:\${CPATH}" >> /container/config_env.sh \
    && echo "export LIBRARY_PATH=${PIO_INSTALL_PATH}/lib:\${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "${PIO_INSTALL_PATH}/lib" >> /etc/ld.so.conf.d/parallelio.conf \
    && ldconfig --verbose \
    && docker-clean
LABEL pnetcdf="${PNETCDF_VERSION}"
LABEL pio="${PIO_VERSION}"



#-------------------------------------------------------------------------------
# FFTW & HEFFTE
FROM ${FFTLIBS_PREREQ} AS fftlibs
#-------------------------------------------------------------------------------
ARG FFTW_VERSION="3.3.10"
ARG HEFFTE_VERSION="2.4.1"
RUN mkdir -p /container/logs && exec &> >(tee /container/logs/fftlibs.log) \
    && echo "building fftw-${FFTW_VERSION}" \
    && env \
    && FFTW_INSTALL_PATH="/container/fftw/${FFTW_VERSION}" \
    && cd /tmp && curl --retry 3 --retry-delay 5 -sSL ftp://fftw.org/pub/fftw/fftw-${FFTW_VERSION}.tar.gz | tar zx \
    && cd ./fftw-${FFTW_VERSION} \
    && ./configure --help \
    && (./configure \
            CFLAGS="-O3 ${CFLAGS}" \
            --prefix=${FFTW_INSTALL_PATH} \
            --disable-static --enable-shared --enable-float \
            --enable-mpi --enable-threads \
            --disable-dependency-tracking \
            || cat config.log) \
    && make --no-print-directory --jobs ${MAKE_J_PROCS:-$(nproc)} V=0 \
    && make --no-print-directory install-strip \
    && make --no-print-directory distclean \
    && (./configure \
            CFLAGS="-O3 ${CFLAGS}" \
            --prefix=${FFTW_INSTALL_PATH} \
            --disable-static --enable-shared \
            --enable-mpi --enable-threads \
            --disable-dependency-tracking \
            || cat config.log) \
    && make --no-print-directory --jobs ${MAKE_J_PROCS:-$(nproc)} V=0 \
    && make --no-print-directory install-strip \
    && echo -e "\n# FFTW ${FFTW_VERSION}" >> /container/config_env.sh \
    && echo "export FFTW_VERSION=${FFTW_VERSION}" >> /container/config_env.sh \
    && echo "export FFTW_ROOT=${FFTW_INSTALL_PATH}" >> /container/config_env.sh \
    && echo "export PATH=${FFTW_INSTALL_PATH}/bin:\${PATH}" >> /container/config_env.sh \
    && echo "export CPATH=${FFTW_INSTALL_PATH}/include:\${CPATH}" >> /container/config_env.sh \
    && echo "export LIBRARY_PATH=${FFTW_INSTALL_PATH}/lib:\${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "${FFTW_INSTALL_PATH}/lib" >> /etc/ld.so.conf.d/fftw.conf \
    && ldconfig --verbose \
    && source /container/config_env.sh \
    && echo "building heffte=${HEFFTE_VERSION} with CPU support" \
    && env \
    && cd /tmp && git clone --branch v${HEFFTE_VERSION} --depth 1 https://github.com/icl-utk-edu/heffte \
    && cd /tmp/heffte && git clean -xdf . && mkdir -p build && cd build \
    && export HEFFTE_INSTALL_PATH="/container/heffte/${HEFFTE_VERSION}-cpu" \
    && cmake \
           -DCMAKE_BUILD_TYPE=Release \
           -DCMAKE_CXX_FLAGS_RELEASE="-O3 -DNDEBUG ${CXXFLAGS}" \
           -DBUILD_SHARED_LIBS=ON \
           -DCMAKE_INSTALL_PREFIX=${HEFFTE_INSTALL_PATH} \
           -DHeffte_ENABLE_FFTW=ON \
           -DFFTW_ROOT=${FFTW_INSTALL_PATH} \
           -DHeffte_ENABLE_CUDA=OFF \
           -DHeffte_ENABLE_ROCM=OFF \
           -DCMAKE_CXX_COMPILER=${CXX} \
           -DMPI_CXX_COMPILER=${CXX} \
           .. \
    && make --no-print-directory --jobs ${MAKE_J_PROCS:-$(nproc)} V=0 \
    && make --no-print-directory install \
    && case "|${CUDA_HOME}|${ROCM_HOME}|" in \
        "|"*"cuda"*"|") \
            cd /tmp/heffte && git clean -xdf . && mkdir -p build && cd build \
                && echo "building heffte=${HEFFTE_VERSION} with CUDA support" \
                && export HEFFTE_INSTALL_PATH="/container/heffte/${HEFFTE_VERSION}-cuda" \
                && export CPATH="$(realpath $(dirname $(which ${CXX}))/../include):${CPATH}" \
                && cmake \
                       -DCMAKE_BUILD_TYPE=Release \
                       -DCMAKE_CXX_FLAGS_RELEASE="-O3 -DNDEBUG ${CXXFLAGS}" \
                       -DBUILD_SHARED_LIBS=ON \
                       -DCMAKE_INSTALL_PREFIX=${HEFFTE_INSTALL_PATH} \
                       -DHeffte_ENABLE_FFTW=ON \
                       -DFFTW_ROOT=${FFTW_INSTALL_PATH} \
                       -DHeffte_ENABLE_CUDA=ON \
                       -DHeffte_ENABLE_ROCM=OFF \
                       -DCUDAToolkit_ROOT=${CUDA_HOME} \
                       -DCMAKE_CUDA_ARCHITECTURES="80;90" \
                       -DCMAKE_CXX_COMPILER=${CXX} \
                       -DMPI_CXX_COMPILER=${CXX} \
                       .. \
                && make --no-print-directory --jobs ${MAKE_J_PROCS:-$(nproc)} V=0 \
                && make --no-print-directory install \
          ;; \
       esac \
    && echo -e "\n# HEFFTE ${HEFFTE_VERSION}" >> /container/config_env.sh \
    && echo "export HEFFTE_VERSION=${HEFFTE_VERSION}" >> /container/config_env.sh \
    && echo "export HEFFTE_ROOT=${HEFFTE_INSTALL_PATH}" >> /container/config_env.sh \
    && echo "export PATH=${HEFFTE_INSTALL_PATH}/bin:\${PATH}" >> /container/config_env.sh \
    && echo "export CPATH=${HEFFTE_INSTALL_PATH}/include:\${CPATH}" >> /container/config_env.sh \
    && echo "export LIBRARY_PATH=${HEFFTE_INSTALL_PATH}/lib64:\${LIBRARY_PATH}" >> /container/config_env.sh \
    && echo "${HEFFTE_INSTALL_PATH}/lib" >> /etc/ld.so.conf.d/heffte.conf \
    && ldconfig --verbose \
    && docker-clean
LABEL fftw="${FFTW_VERSION}"
LABEL heffte="${HEFFTE_VERSION}"



################################################################################
# Final Image
################################################################################
FROM ${FINAL_TARGET} AS final
RUN mkdir -p /container/logs && exec &> >(tee /container/logs/final.log) \
    && echo "Final configuration:" \
    && mkdir -p /container/extras/ \
    && echo -e "\n# (container image build completed at $(date))" >> /container/config_env.sh \
    && 2>/dev/null du -hs /container/*/ /*/ | grep -v "K" | sort \
    && cat /container/config_env.sh
ADD extras/Dockerfile.* extras/build*.sh extras/*.cfg extras/install*.sh extras/hello*.* /container/extras/

# Local Variables:
# mode: sh
# End:
