# ref build:
# docker buildx build --build-arg "BASE_IMAGE=alpine:latest" --no-cache --progress plain .

ARG BASE_IMAGE="alpine:latest"

#-------------------------------------------------------------------------------
FROM ${BASE_IMAGE} AS base-image
#-------------------------------------------------------------------------------

RUN cat /etc/os-release

RUN /container/extras/build_osu-micro-benchmarks.sh

# Local Variables:
# mode: sh
# End:
