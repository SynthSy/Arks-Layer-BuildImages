#!/bin/sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

# Set same default compilation flags as abuild.
export CFLAGS="-Os -fomit-frame-pointer"
export CXXFLAGS="$CFLAGS"
export CPPFLAGS="$CFLAGS"
export LDFLAGS="-Wl,--strip-all -Wl,--as-needed"

export CC=xx-clang
export CXX=xx-clang++

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

VERBOSE_BUILD=0

apk --no-cache add \
    linux-headers \
    alpine-sdk \
    autoconf \
    automake \
    bash \
    bind-tools \
	gettext \
    bison \
    coreutils \
    curl \
	cmake \
    patch \
	git \
	openssh \
	icu-libs \
    clang \
    binutils \
    ruby-rake \
    pkgconf \
	python3 \
	py3-pip \
	py3-virtualenv \
	wget \
	xz

xx-apk --no-cache --no-scripts add \
    musl-dev \
    gcc \
    g++ \
	zlib-dev \
	cmark-dev \
	libtool

mkdir /tmp/mono-install

(	
    cd /tmp && \
    git clone https://gitlab.winehq.org/mono/mono.git && \
	cd mono && \
	./autogen.sh && \
	make check -j$(nproc)
)

ls -l /tmp/mono-dev

DESTDIR=/tmp/mono-install make -f /tmp/mono-dev/makefile install
