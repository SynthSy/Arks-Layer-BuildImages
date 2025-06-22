# Get Dockerfile cross-compilation helpers.
FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx

# base image
FROM cimg/python:3.11-node
COPY --from=xx / /

# install rsync
RUN xx-apt update && xx-apt install --no-install-recommends -y \
    rsync
