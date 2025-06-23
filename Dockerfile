ARG ALPINE_VERSION=3.19
FROM docker.io/alpine:$ALPINE_VERSION AS build

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
        file \
        findutils \
        gettext \
        gettext-dev \
        gperf \
		git \
        jq \
		nodejs \
		parallel \
		python3 \
		py3-pip \
        rsync \
		openssh \
        texinfo \
        wget \
        xz \
		yarn
		
# upgrade grep to gnu grep
RUN apk add --no-cache --upgrade grep

RUN env PYTHON_CONFIGURE_OPTS="--enable-shared --enable-optimizations" pyenv install %%MAIN_VERSION%% && pyenv global %%MAIN_VERSION%%

RUN pip install --upgrade pip && \
    pip install pipenv wheel pillow && \
	pip install --user pipx

# https://github.com/upx/upx
ARG UPX_VERSION=4.0.2
RUN set -xeu; \
    curl -#Lo upx.tar.xz \
        "https://github.com/upx/upx/releases/download/v$UPX_VERSION/upx-$UPX_VERSION-amd64_linux.tar.xz"; \
    tar -xvf upx.tar.xz --strip-components=1 "upx-$UPX_VERSION-amd64_linux/upx"; \
    chmod +x upx; \
    mv upx /usr/local/bin/upx; \
    rm -f upx.tar.xz
	
ENTRYPOINT ["/bin/bash"]
