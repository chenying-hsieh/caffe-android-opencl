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
CLBLAS_ROOT=${WD}/clBLAS/src
ANDROID_LIB_ROOT=${WD}/android_lib
OPENCL_ROOT=${ANDROID_LIB_ROOT}/opencl/1.2
BUILD_DIR=${CLBLAS_ROOT}/build
INSTALL_DIR=${WD}/android_lib
BOOST_HOME=${ANDROID_LIB_ROOT}/boost
N_JOBS=${N_JOBS:-4}

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

cmake -DCMAKE_TOOLCHAIN_FILE="${WD}/android-cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${NDK_ROOT}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DBOOST_ROOT="${BOOST_HOME}" \
      -DANDROID_ABI="${ANDROID_ABI}" \
      -DANDROID_NATIVE_API_LEVEL=21 \
      -DOPENCL_INCLUDE_DIRS=${OPENCL_ROOT} \
      -DOPENCL_LIBRARIES=${OPENCL_ROOT}/libOpenCL.so \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/clblas-hard" \
      -DPYTHON_EXECUTABLE="/usr/bin/python" \
      -DBUILD_TEST=OFF \
      -DBUILD_SAMPLE=ON \
      -DBUILD_KTEST=OFF \
      -DBUILD_CLIENT=OFF \
      -DBUILD_PERFORMANCE=OFF \
      -DBoost_DIR=${BOOST_HOME} \
      -DBoost_INCLUDE_DIR=${BOOST_HOME}/include \
      -DBoost_PROGRAM_OPTIONS_LIBRARY=${BOOST_HOME}/lib/libboost_program_options.a \
      ..
      #-DINCLUDE_DIR="/opt/toolchains/android-ndk-r14b/sources/cxx-stl/gnu-libstdc++/4.9/libs/armeabi-v7a/include" \

make -j${N_JOBS} VERBOSE=1
make install/strip

cd "${WD}"
#rm -rf "${BUILD_DIR}"
