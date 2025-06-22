# base image
FROM cimg/python:3.11-node

# install rsync
RUN apt-get update && apt-get install --no-install-recommends -y \
    rsync
