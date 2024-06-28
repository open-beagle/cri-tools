#!/bin/bash
set -ex

name=cri-tools
version=v1.30.0

if [ ! -d ${BUILD_ROOT}/.tmp/${name}-${version} ]; then
  git config --global http.proxy 'socks5://www.ali.wodcloud.com:1283'
  git clone --recurse-submodules -b ${version} https://github.com/kubernetes-sigs/cri-tools ${BUILD_ROOT}/.tmp/${name}-${version}
fi

cd ${BUILD_ROOT}/.tmp/${name}-${version}

mkdir -p ${BUILD_ROOT}/.dist/amd64
export GOARCH=amd64
make binaries
cp ${BUILD_ROOT}/.tmp/${name}-${version}/build/bin/linux/amd64/crictl ${BUILD_ROOT}/.dist/amd64/crictl

mkdir -p ${BUILD_ROOT}/.dist/arm64
export GOARCH=arm64
make binaries
cp ${BUILD_ROOT}/.tmp/${name}-${version}/build/bin/linux/arm64/crictl ${BUILD_ROOT}/.dist/arm64/crictl
