FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx

FROM --platform=$BUILDPLATFORM debian:trixie-slim AS debian
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
	unzip \
	wget \
	zip

ADD https://astral.sh/uv/0.11.8/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh
ENV PATH="/root/.local/bin/:$PATH"

# https://github.com/upx/upx
ARG UPX_VERSION=5.1.1
RUN set -xeu; \
    curl -#Lo upx.tar.xz \
        "https://github.com/upx/upx/releases/download/v$UPX_VERSION/upx-$UPX_VERSION-amd64_linux.tar.xz"; \
    tar -xvf upx.tar.xz --strip-components=1 "upx-$UPX_VERSION-amd64_linux/upx"; \
    chmod +x upx; \
    mv upx /usr/local/bin/upx; \
    rm -f upx.tar.xz
	
ENTRYPOINT ["/bin/bash"]
