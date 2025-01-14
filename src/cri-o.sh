#!/bin/bash
set -ex

name=cri-o
version=v1.30.8

SOCKS5_PROXY_LOCAL="${SOCKS5_PROXY:-$SOCKS5_PROXY_LOCAL}"

if [ ! -d ${BUILD_ROOT}/.tmp/${name}-${version} ]; then
  git config --global http.proxy $SOCKS5_PROXY_LOCAL
  git clone --recurse-submodules -b ${version} https://github.com/cri-o/cri-o ${BUILD_ROOT}/.tmp/${name}-${version}
fi

cd ${BUILD_ROOT}/.tmp/${name}-${version}

export GO=xx-go 
export CFLAGS='-static -pthread'
export LDFLAGS='-s -w -static-libgcc -static'
export EXTRA_LDFLAGS='-s -w -linkmode external -extldflags "-static -lm"'
export BUILDTAGS='static netgo osusergo exclude_graphdriver_btrfs seccomp apparmor selinux'
export CGO_LDFLAGS='-lgpgme -lassuan -lgpg-error'
export CGO_ENABLED=1

mkdir -p ${BUILD_ROOT}/.dist/amd64
export TARGETPLATFORM=linux/amd64
xx-apk add libseccomp-dev gpgme-dev libapparmor libassuan libgpg-error libselinux lvm2-dev
make clean
make binaries
mv ${BUILD_ROOT}/.tmp/${name}-${version}/bin/crio ${BUILD_ROOT}/.dist/amd64/crio
mv ${BUILD_ROOT}/.tmp/${name}-${version}/bin/pinns ${BUILD_ROOT}/.dist/amd64/pinns

mkdir -p ${BUILD_ROOT}/.dist/arm64
export TARGETPLATFORM=linux/arm64
xx-apk add libseccomp-dev gpgme-dev libapparmor libassuan libgpg-error libselinux lvm2-dev
make clean
make binaries
mv ${BUILD_ROOT}/.tmp/${name}-${version}/bin/crio ${BUILD_ROOT}/.dist/arm64/crio
mv ${BUILD_ROOT}/.tmp/${name}-${version}/bin/pinns ${BUILD_ROOT}/.dist/arm64/pinns
