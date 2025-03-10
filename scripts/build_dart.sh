#!/usr/bin/env bash

set -ex

export DART_VERSION="${DART_VERSION:-v11.8.8}"

topdir="$(pwd)"
INSTALL_ROOT="${INSTALL_ROOT:-/container}"
STAGE_DIR="${STAGE_DIR:-/tmp}"

DART_SRC="${STAGE_DIR}/DART-${DART_VERSION}"

#--------------------------------------------------------------------------------
# prep source
[ -d "${DART_SRC}" ] || git clone --branch ${DART_VERSION} --depth=1 https://github.com/NCAR/DART.git ${DART_SRC}
cd ${DART_SRC} && git clean -xdf .


#--------------------------------------------------------------------------------
# create a suitable mkmf.template
cat <<EOF > ${DART_SRC}/build_templates/mkmf.template
NETCDF = ${NETCDF}
INCS = -I${NETCDF}/include
LIBS = -L${NETCDF}/lib -lnetcdf -lnetcdff
MPIFC := mpif90
MPILD := mpif90
EOF

case "${COMPILER_FAMILY}" in

    "aocc")
        cat <<EOF >> ${DART_SRC}/build_templates/mkmf.template
FC := flang
LD := flang
FFLAGS = -O2 \$(INCS)
LDFLAGS = \$(FFLAGS) \$(LIBS)
EOF
        ;;

    "gcc")
        cat <<EOF >> ${DART_SRC}/build_templates/mkmf.template
FC := gfortran
LD := gfortran
FFLAGS = -O2 -ffree-line-length-none \$(INCS)
LDFLAGS = \$(FFLAGS) \$(LIBS)
EOF
        ;;

    "nvhpc")
        cat <<EOF >> ${DART_SRC}/build_templates/mkmf.template
FC := nvfortran
LD := nvfortran
FFLAGS = -O -Kieee -Mbackslash \$(INCS)
LDFLAGS = \$(FFLAGS) \$(LIBS)
EOF
        ;;

    "oneapi")
        cat <<EOF >> ${DART_SRC}/build_templates/mkmf.template
FC := ifx
LD := ifx
FFLAGS = -O -assume buffered_io \$(INCS)
LDFLAGS = \$(FFLAGS) \$(LIBS)
EOF
        ;;

    *)
        echo "ERROR: unrecognized COMPILER_FAMILY: ${COMPILER_FAMILY}!!"
        exit 1
        ;;
esac
cat ${DART_SRC}/build_templates/mkmf.template


#--------------------------------------------------------------------------------
# build an example
cd ${DART_SRC}/models/lorenz_63/work
./quickbuild.sh help
./quickbuild.sh
find $(pwd) -executable -ls
