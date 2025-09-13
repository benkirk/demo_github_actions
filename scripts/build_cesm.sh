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

${PKG_INSTALL_CMD} perl-English perl-FindBin perl-Math-BigInt perl-App-cpanminus perl-XML-LibXML

find /container/esmf -name esmf.mk \
    || /container/extras/build_esmf.sh

export ESMFMKFILE="$(find /container/esmf -name esmf.mk)"

export CESM_VERSION="${CESM_VERSION:-3.0-alpha}"

CESM_SRC="${STAGE_DIR}/CESM-${CESM_VERSION}"
CESM_BUILD_DIR="${CESM_SRC}/BUILD"
CESM_INSTALL_DIR="${INSTALL_ROOT}/CESM/${CESM_VERSION}"

export CESMDATAROOT=/data/cesm && mkdir -p ${CESMDATAROOT}
export USER="$(whoami)"
#--------------------------------------------------------------------------------
# prep source
if [ ! -d "${CESM_SRC}" ]; then
    #git clone --branch release-cesm${CESM_VERSION} --depth=1  https://github.com/ESCOMP/CESM.git ${CESM_SRC}
    git clone --branch cesm3.0-alphabranch --depth=1 https://github.com/ESCOMP/CESM.git ${CESM_SRC}
    cd ${CESM_SRC}
    #./manage_externals/checkout_externals
    ./bin/git-fleximod update
fi
cd ${CESM_SRC} && git clean -xdf .

cat << EOF > ccs_config/machines/container/config_machines.xml
  <machine MACH="container">
    <DESC>
      Containerized development environment (Docker/Singularity) for CESM w/ GNU compilers
    </DESC>
    <OS>LINUX</OS>
    <COMPILERS>gnu</COMPILERS>
    <MPILIBS>mpich</MPILIBS>
    <CIME_OUTPUT_ROOT>$ENV{HOME}/scratch</CIME_OUTPUT_ROOT>
    <DIN_LOC_ROOT>$ENV{CESMDATAROOT}/inputdata</DIN_LOC_ROOT>
    <DIN_LOC_ROOT_CLMFORC>$DIN_LOC_ROOT/atm/datm7</DIN_LOC_ROOT_CLMFORC>
    <DOUT_S_ROOT>$ENV{HOME}/archive/$CASE</DOUT_S_ROOT>
    <GMAKE>make</GMAKE>
    <GMAKE_J>4</GMAKE_J>
    <BATCH_SYSTEM>none</BATCH_SYSTEM>
    <SUPPORTED_BY>cgd</SUPPORTED_BY>
    <MAX_TASKS_PER_NODE>4</MAX_TASKS_PER_NODE>
    <MAX_MPITASKS_PER_NODE>4</MAX_MPITASKS_PER_NODE>
    <PROJECT_REQUIRED>FALSE</PROJECT_REQUIRED>
    <mpirun mpilib="mpich">
      <executable>mpiexec</executable>
      <arguments>
        <arg name="anum_tasks"> -n {{ total_tasks }}</arg>
      </arguments>
    </mpirun>
    <module_system type="none">
    </module_system>
    <environment_variables>
      <env name="NETCDF_PATH">${NETCDF}</env>
      <env name="PNETCDF_PATH">${PNETCDF}</env>
      <env name="FPATH">/usr/lib64</env>
      <env name="CPATH">/usr/lib64</env>
    </environment_variables>
  </machine>
EOF

cat << EOF > ccs_config/machines/container/container.cmake
if (COMP_NAME STREQUAL gptl)
  string(APPEND CPPDEFS " -DHAVE_NANOTIME -DBIT64 -DHAVE_VPRINTF -DHAVE_BACKTRACE -DHAVE_SLASHPROC -DHAVE_COMM_F2C -DHAVE_TIMES -DHAVE_GETTIMEOFDAY")
endif()
set(NETCDF_PATH "${NETCDF}")
set(PNETCDF_PATH "${PNETCDF}")
set(LDFLAGS "")
string(APPEND SLIBS " -lnetcdf -lnetcdff")
EOF

git diff

mkdir -p ${CESM_BUILD_DIR}

ln -sf /usr/bin/python{3,}
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

rm -rf /tmp/foo-case
./cime/scripts/create_newcase --machine container --case /tmp/foo-case --compset FHIST --res f19_g17 --run-unsupported
cd /tmp/foo-case/
./case.setup
./case.build
exit 0
