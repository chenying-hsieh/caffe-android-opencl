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
OPENCL_ROOT=${ANDROID_LIB_ROOT}/opencl/1.2
BUILD_DIR=${VIENNACL_ROOT}/cmake
INSTALL_DIR=${WD}/android_lib
N_JOBS=${N_JOBS:-4}
#BOOST_HOME=${WD}/boost/boost_1_56_0
BOOST_HOME=${ANDROID_LIB_ROOT}/boost

#rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

cmake -DCMAKE_TOOLCHAIN_FILE="${WD}/android-cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${NDK_ROOT}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_ABI="${ANDROID_ABI}" \
      -DANDROID_NATIVE_API_LEVEL=21 \
      -DOPENCL_LIBRARY=${OPENCL_ROOT}/libOpenCL.so \
      -DOPENCL_INCLUDE_DIR=${OPENCL_ROOT} \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/viennacl-hard" \
      -DVIENNACL_HOME=${VIENNACL_ROOT} \
      -DOpenBLAS_INCLUDE_DIR=${OPENBLAS_ROOT}/include \
      -DOpenBLAS_LIB=${OPENBLAS_ROOT}/lib/libopenblas.a \
      -DBOOST_ROOT=${BOOST_HOME} \
      -DBoost_Version="1.56.0" \
      -DBoost_INCLUDE_DIR=${BOOST_HOME}/include \
      -DBOOST_LIBRARYDIR=${BOOST_HOME}/lib \
      -DBLAS="Open" \
      -DBUILD_TESTING=OFF \
      ..


make -j${N_JOBS} VERBOSE=1
#rm -rf "${INSTALL_DIR}/boost"
make install/strip

cd "${WD}"
#rm -rf "${BUILD_DIR}"
