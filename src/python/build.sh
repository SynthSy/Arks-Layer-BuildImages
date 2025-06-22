#!/bin/sh
set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

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

PYTHON_URL="$1"

if [ -z "$PYTHON_URL" ]; then
    log "ERROR: Python URL missing."
    exit 1
fi

apk --no-cache add \
    curl \
	patch \
	clang \
	binutils \
    ruby-rake \
    pkgconf \
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
	jq \
	rsync \
	texinfo \
	wget \
	xz
	
xx-apk --no-cache --no-scripts add \
    musl-dev \
    gcc \
    g++ \	
	
log "Downloading Python 3.11 package..."
mkdir /tmp/python3.11
curl -# -L -f ${PYTHON_URL} | tar -tf --strip 2 -C /tmp/python3.11

log "Compiling Python 3.11..."
(
    cd /tmp/python && \
    
)