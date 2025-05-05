ARG BASE_IMAGE="invalid"

#-------------------------------------------------------------------------------
FROM ${BASE_IMAGE} AS base-image
#-------------------------------------------------------------------------------

# a colon ':' separated list of scripts to execute; including their result in the final image
ARG DEPLOYMENT_SCRIPTS="/container/extras/build_osu-micro-benchmarks.sh"

#-------------------------------------------------------------------------------
FROM base-image AS final
#-------------------------------------------------------------------------------
SHELL ["/bin/bash", "--login", "-c"]
RUN echo "Publishing Production Image from ${BASE_IMAGE} ..." \
    && SCRIPTS="${DEPLOYMENT_SCRIPTS}" \
    && for script in ${SCRIPTS//:/ }; do \
         [ -x "${script}" ] \
             && echo "Executing Deployment Script ${script} ..." \
             && exec ${script} \
             && echo "# --> ${script} run on $(date) and included in image." >> /container/config_env.sh \
             || { echo "${script} not executable or does not exist??"; ls -l ${script}; continue; }; \
       done \
    && echo "# ${PUBLISH_IMAGE_TAG} created on $(date)" >> /container/config_env.sh \
    && docker-clean

# Local Variables:
# mode: sh
# End:
