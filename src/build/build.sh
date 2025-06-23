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

function log {
    echo ">>> $*"
}

MONO_URL="https://download.mono-project.com/sources/mono/mono-6.12.0.199.tar.xz"

if [ -z "$MONO_URL" ]; then
    log "ERROR: Mono URL missing."
    exit 1
fi

apk --no-cache add \
    alpine-sdk \
    autoconf \
    automake \
    bash \
    bind-tools \
    bison \
    coreutils \
    curl \
    patch \
    clang \
    binutils \
    ruby-rake \
    pkgconf \
	python3 \
	py3-pip \
	py3-virtualenv \
	xz

xx-apk --no-cache --no-scripts add \
    musl-dev \
    gcc \
    g++ \
	zlib-dev \
	cmark-dev

log "Downloading mono-dev package..."
mkdir /tmp/mono-dev
mkdir /tmp/mono-install
curl -# -L -f ${MONO_URL} | tar -xzf --strip 2 -C /tmp/mono-dev

log "Compiling..."
cd /tmp/mono-dev && make check -j$(nproc)

log "display directory for debugging purposes..."
ls -l /tmp/mono-dev

log "Installing..."
DESTDIR=/tmp/mono-install make -f /tmp/mono-dev/makefile install
