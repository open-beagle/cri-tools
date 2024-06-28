#!/bin/bash

BUILD_ROOT="$(pwd)"
BUILD_ARCH="${BUILD_ARCH:-amd64}"

rm -rf "${BUILD_ROOT}/.dist/${BUILD_ARCH}"
mkdir -p "${BUILD_ROOT}/.tmp" "${BUILD_ROOT}/.dist/${BUILD_ARCH}"

source ${BUILD_ROOT}/src/cri-tools.sh
