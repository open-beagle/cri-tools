#!/bin/bash
set -ex

name=cri-tools
version=v1.30.1

SOCKS5_PROXY_LOCAL="${SOCKS5_PROXY:-$SOCKS5_PROXY_LOCAL}"

if [ ! -d ${BUILD_ROOT}/.tmp/${name}-${version} ]; then
  git config --global http.proxy $SOCKS5_PROXY_LOCAL
  git clone --recurse-submodules -b ${version} https://github.com/kubernetes-sigs/cri-tools ${BUILD_ROOT}/.tmp/${name}-${version}
fi

cd ${BUILD_ROOT}/.tmp/${name}-${version}

mkdir -p ${BUILD_ROOT}/.dist/amd64
export TARGETPLATFORM=linux/amd64
xx-go --wrap
make binaries
cp ${BUILD_ROOT}/.tmp/${name}-${version}/build/bin/linux/amd64/crictl ${BUILD_ROOT}/.dist/amd64/crictl

mkdir -p ${BUILD_ROOT}/.dist/arm64
export TARGETPLATFORM=linux/arm64
xx-go --wrap
make binaries
cp ${BUILD_ROOT}/.tmp/${name}-${version}/build/bin/linux/arm64/crictl ${BUILD_ROOT}/.dist/arm64/crictl
