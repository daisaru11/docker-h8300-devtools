#!/bin/sh

set -ex

DEPS='libgmp-dev libmpx2 libmpc-dev'
BUILD_DEPS='curl bzip2 make gcc g++'

apt-get update
apt-get install -y $BUILD_DEPS $DEPS

BINUTILS_VERSION='2.31.1'
GCC_VERSION='8.2.0'
TARGET='h8300-elf'


# Download src
mkdir /src
cd /src

curl "http://ftp.jaist.ac.jp/pub/GNU/binutils/binutils-${BINUTILS_VERSION}.tar.bz2" -o binutils-${BINUTILS_VERSION}.tar.bz2
curl "http://ftp.jaist.ac.jp/pub/GNU/gcc/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.gz" -o gcc-${GCC_VERSION}.tar.gz
tar xf binutils-${BINUTILS_VERSION}.tar.bz2
tar xf gcc-${GCC_VERSION}.tar.gz

# Build binutils
cd /src/binutils-${BINUTILS_VERSION}
./configure --target=${TARGET} --disable-nls --disable-werror
make
make install

# Build gcc
mkdir -p /src/gcc-${GCC_VERSION}/build-${TARGET}
cd /src/gcc-${GCC_VERSION}/build-${TARGET}
../configure --target=${TARGET} --disable-nls --disable-werror --disable-shared --disable-libssp --enable-languages=c
make
make install

# Clean up
apt-get purge -y --auto-remove $BUILD_DEPS
apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /src
