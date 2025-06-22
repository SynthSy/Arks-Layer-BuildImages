# Get Dockerfile cross-compilation helpers.
FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx

# base image
FROM cimg/python:3.11-node as debian
COPY --from=xx / /
RUN apt-get update && apt-get upgrade --no-install-recommends -y

# install rsync
FROM debian
RUN xx-apt install --no-install-recommends -y \
    rsync
