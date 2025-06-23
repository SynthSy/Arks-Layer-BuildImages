FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx

FROM --platform=$BUILDPLATFORM debian:bookworm-slim AS debian
COPY --from=xx / /
ARG TARGETPLATFORM
RUN apt-get update \
    && apt-get install -y --no-install-recommends bash \
	build-essential \
	ca-certificates \
	ca-certificates-mono \
	cmake \
	curl \
	dirmngr \
	git \
	gnupg \
	mono-devel \
	openssh-client \
	parallel \
	python3.11 \
	python3-venv \
	python3-pip \
	unzip \
	wget \
	zip

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
