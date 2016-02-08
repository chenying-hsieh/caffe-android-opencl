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

ANDROID_ABI=${ANDROID_ABI:-"armeabi-v7a-hard with NEON"}
WD=`pwd`
N_JOBS=${N_JOBS:-4}
CAFFE_ROOT=${WD}/caffe-opencl
BUILD_DIR=${CAFFE_ROOT}/build
ANDROID_LIB_ROOT=${WD}/android_lib
OPENCV_ROOT=${ANDROID_LIB_ROOT}/opencv/sdk/native/jni
PROTOBUF_ROOT=${ANDROID_LIB_ROOT}/protobuf
GFLAGS_HOME=${ANDROID_LIB_ROOT}/gflags
BOOST_HOME=${ANDROID_LIB_ROOT}/boost_1.56.0
OPENCL_ROOT=${ANDROID_LIB_ROOT}/opencl
OPENBLAS_ROOT=${WD}/android_lib/openblas-hard
VIENNACL_ROOT=${ANDROID_LIB_ROOT}/viennacl-hard


rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

cmake -DCMAKE_TOOLCHAIN_FILE="${WD}/android-cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${NDK_ROOT}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_ABI="${ANDROID_ABI}" \
      -DANDROID_NATIVE_API_LEVEL=21 \
      -DANDROID_USE_OPENMP=ON \
      -DADDITIONAL_FIND_PATH="${ANDROID_LIB_ROOT}" \
      -DBUILD_python=OFF \
      -DBUILD_docs=OFF \
      -DCPU_ONLY=OFF \
      -DUSE_CUDA=OFF \
      -DOPENCL_LIBRARIES=${OPENCL_ROOT}/libOpenCL.so \
      -DOPENCL_INCLUDE_DIRS=${OPENCL_ROOT} \
      -DVIENNACL_HOME=${VIENNACL_ROOT} \
      -DOpenBLAS_INCLUDE_DIR=${OPENBLAS_ROOT}/include \
      -DOpenBLAS_LIB=${OPENBLAS_ROOT}/lib/libopenblas.a \
      -DBLAS="Open" \
      -DUSE_GLOG=OFF \
      -DUSE_LMDB=OFF \
      -DUSE_LEVELDB=OFF \
      -DUSE_HDF5=OFF \
      -DBOOST_ROOT="${BOOST_HOME}" \
      -DGFLAGS_INCLUDE_DIR="${GFLAGS_HOME}/include" \
      -DGFLAGS_LIBRARY="${GFLAGS_HOME}/lib/libgflags.a" \
      -DOpenCV_DIR="${OPENCV_ROOT}" \
      -DPROTOBUF_PROTOC_EXECUTABLE=`which protoc` \
      -DGIT_EXECUTABLE=`which git` \
      -DPROTOBUF_INCLUDE_DIR="${PROTOBUF_ROOT}/include" \
      -DPROTOBUF_LIBRARY="${PROTOBUF_ROOT}/lib/libprotobuf.a" \
      -DCMAKE_INSTALL_PREFIX="${ANDROID_LIB_ROOT}/caffe-opencl" \
      ..

make -j${N_JOBS}
rm -rf "${ANDROID_LIB_ROOT}/caffe-opencl"
make install/strip

cd "${WD}"
