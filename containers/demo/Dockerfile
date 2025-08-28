# ref build:
# docker buildx build --build-arg "BASE_IMAGE=alpine:latest" --no-cache --progress plain .

ARG BASE_IMAGE="alpine:latest"

#-------------------------------------------------------------------------------
FROM ${BASE_IMAGE} AS base-image
#-------------------------------------------------------------------------------
RUN cat /etc/os-release

#-------------------------------------------------------------------------------
FROM base-image AS final
#-------------------------------------------------------------------------------
RUN cat <<EOF > /container/my_buildscript.sh
\${MPICXX} -o /container/speak.exe /container/extras/hello_world_mpi.cxx -fopenmp
EOF

RUN echo "Building my application..." \
    && chmod +x /container/my_buildscript.sh \
    && /container/my_buildscript.sh \
    && ldd /container/speak.exe \
    && /container/speak.exe \
    && docker-clean

# Local Variables:
# mode: sh
# End:
