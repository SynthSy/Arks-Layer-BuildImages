FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx
ARG MONO_URL=https://download.mono-project.com/sources/mono/mono-6.12.0.199.tar.xz

# compile mono-dev
FROM --platform=$BUILDPLATFORM alpine:3.19 AS mono-dev
COPY --from=xx / /
ARG TARGETPLATFORM
ARG MONO_URL
COPY src/build /build
RUN chmod +x /build/build.sh && /build/build.sh "$MONO_URL"
RUN xx-verify \
    /tmp/mono-install/usr/bin/mono

FROM docker.io/alpine:3.19 AS build

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
		python3 \
		py3-pip \
		py3-virtualenv \
        rsync \
		openssh \
        texinfo \
        wget \
        xz \
		yarn
		
# upgrade grep to gnu grep
RUN apk add --no-cache --upgrade grep

# https://github.com/upx/upx
ARG UPX_VERSION=4.0.2
RUN set -xeu; \
    curl -#Lo upx.tar.xz \
        "https://github.com/upx/upx/releases/download/v$UPX_VERSION/upx-$UPX_VERSION-amd64_linux.tar.xz"; \
    tar -xvf upx.tar.xz --strip-components=1 "upx-$UPX_VERSION-amd64_linux/upx"; \
    chmod +x upx; \
    mv upx /usr/local/bin/upx; \
    rm -f upx.tar.xz
	
COPY --from=mono-dev /tmp/mono-install/usr/bin /usr/bin
	
ENTRYPOINT ["/bin/bash"]
