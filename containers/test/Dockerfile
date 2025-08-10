ARG BASE_IMAGE="invalid"

#-------------------------------------------------------------------------------
FROM ${BASE_IMAGE} AS base-image
#-------------------------------------------------------------------------------

# a colon ':' separated list of scripts to execute; including their result in the final image
ARG TEST_SCRIPTS="/container/extras/build_osu-micro-benchmarks.sh"

#-------------------------------------------------------------------------------
FROM base-image AS test
#-------------------------------------------------------------------------------
SHELL ["/bin/bash", "--login", "-c"]
RUN echo "Testing Image from ${BASE_IMAGE} ..." \
    && env \
    && cat /container/config_env.sh \
    && docker-clean

RUN echo "Testing Image from ${BASE_IMAGE} ..." \
    && ls /container/extras/*.sh \
    && SCRIPTS="${TEST_SCRIPTS}" \
    && for script in ${SCRIPTS//:/ }; do \
        [ -x "${script}" ] \
            && echo "-------------------------------------------------------------------------------" \
            && echo "Executing Test Script ${script} ..." \
            && echo "-------------------------------------------------------------------------------" \
            && exec ${script} \
                || { echo "${script} not executable or does not exist??"; ls -l ${script}; continue; }; \
       done \
    && docker-clean

# Local Variables:
# mode: sh
# End:
