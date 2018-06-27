#!/usr/bin/env sh
set -e

if [ -z "$NDK_ROOT" ] && [ "$#" -eq 0 ]; then
    echo 'Either $NDK_ROOT should be set or provided as argument'
    echo "e.g., 'export NDK_ROOT=/path/to/ndk' or"
    echo "      '${0} /path/to/ndk'"
    exit 1
else
    NDK_ROOT="${1:-${NDK_ROOT}}"
fi

ANDROID_ABI=${ANDROID_ABI:-"armeabi-v7a with NEON"}
#ANDROID_ABI=${ANDROID_ABI:-"arm64-v8a"}
WD=`pwd`
LMDB_ROOT=${WD}/lmdb/libraries/liblmdb/
ANDROID_LIB_ROOT=${WD}/android_lib
BUILD_DIR=${LMDB_ROOT}/build
INSTALL_DIR=${WD}/android_lib
N_JOBS=${N_JOBS:-4}

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

cmake -DCMAKE_TOOLCHAIN_FILE="${WD}/android-cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${NDK_ROOT}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_ABI="${ANDROID_ABI}" \
      -DANDROID_NATIVE_API_LEVEL=21 \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/lmdb" \
      ..

make -j${N_JOBS} VERBOSE=1
make install/strip

cd "${WD}"
rm -rf "${BUILD_DIR}"
