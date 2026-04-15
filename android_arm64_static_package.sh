#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${BUILD_DIR:-/tmp/unicorn-android-arm64-build}"
INSTALL_DIR="${INSTALL_DIR:-/tmp/unicorn-android-arm64-install}"
OUTPUT_DIR="${1:-${REPO_ROOT}/output/android-arm64}"
NDK_PATH="${ANDROID_NDK:-${ANDROID_NDK_HOME:-}}"
MIN_API="${ANDROID_NATIVE_API_LEVEL:-28}"
PACKAGE_NAME="unicorn-android-arm64-static.tar.gz"

if [[ -z "${NDK_PATH}" ]]; then
  echo "Error: ANDROID_NDK or ANDROID_NDK_HOME is not set." >&2
  exit 1
fi

mkdir -p "${BUILD_DIR}" "${INSTALL_DIR}" "${OUTPUT_DIR}"

cmake -S "${REPO_ROOT}" -B "${BUILD_DIR}" \
  -DCMAKE_TOOLCHAIN_FILE="${NDK_PATH}/build/cmake/android.toolchain.cmake" \
  -DANDROID_ABI=arm64-v8a \
  -DANDROID_NATIVE_API_LEVEL="${MIN_API}" \
  -DBUILD_SHARED_LIBS=OFF \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}"

cmake --build "${BUILD_DIR}" --config Release
cmake --install "${BUILD_DIR}" --config Release

tar -C "${INSTALL_DIR}" -czf "${OUTPUT_DIR}/${PACKAGE_NAME}" .

printf 'Built package: %s\n' "${OUTPUT_DIR}/${PACKAGE_NAME}"
