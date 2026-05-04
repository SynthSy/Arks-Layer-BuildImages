FROM docker.io/alpine:3.23 AS build

# hadolint ignore=DL3018
RUN apk add --no-cache \
        aspell \
        aspell-en \
        alpine-sdk \
        autoconf \
        automake \
        bash \
        bind-tools \
        bison \
        coreutils \
        curl \
        ca-certificates \
        file \
        findutils \
        gettext \
        gettext-dev \
        gperf \
        git \
        jq \
        libgdiplus-dev \
        nodejs \
        parallel \
        pkgconf \
        rsync \
        openssh \
        texinfo \
        wget \
        xz \
        yarn
		
# upgrade grep to gnu grep
RUN apk add --no-cache --upgrade grep

# Install UV and python 3.11
ADD https://astral.sh/uv/0.11.8/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh
ENV PATH="/root/.local/bin/:$PATH"

RUN uv python install 3.11

# https://github.com/upx/upx
ARG UPX_VERSION=5.1.1
RUN set -xeu; \
    curl -#Lo upx.tar.xz \
        "https://github.com/upx/upx/releases/download/v${UPX_VERSION}/upx-${UPX_VERSION}-amd64_linux.tar.xz"; \
    tar -xvf upx.tar.xz --strip-components=1 "upx-$UPX_VERSION-amd64_linux/upx"; \
    chmod +x upx; \
    mv upx /usr/local/bin/upx; \
    rm -f upx.tar.xz
	
ENTRYPOINT ["/bin/bash"]
