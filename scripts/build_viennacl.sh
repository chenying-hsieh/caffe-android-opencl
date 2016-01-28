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
WD=`pwd`
VIENNACL_ROOT=${WD}/ViennaCL-1.7.1
ANDROID_LIB_ROOT=${WD}/android_lib
OPENCL_ROOT=${ANDROID_LIB_ROOT}/opencl
BUILD_DIR=${VIENNACL_ROOT}/build
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
      -DOPENCL_LIBRARY=${OPENCL_ROOT}/libOpenCL.so \
      -DOPENCL_INCLUDE_DIR=${OPENCL_ROOT} \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/viennacl" \
      ..

make -j${N_JOBS}
rm -rf "${INSTALL_DIR}/boost"
make install/strip

cd "${WD}"
rm -rf "${BUILD_DIR}"
