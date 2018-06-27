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

#ANDROID_ABI=${ANDROID_ABI:-"armeabi-v7a-hard with NEON"}
ANDROID_ABI=${ANDROID_ABI:-"armeabi-v7a with NEON"}
#ANDROID_ABI=${ANDROID_ABI:-"arm64-v8a"}
WD=${WD:-`pwd`}
N_JOBS=${N_JOBS:-4}
CAFFE_ROOT=${WD}/caffe
BUILD_DIR=${CAFFE_ROOT}/build
ANDROID_LIB_ROOT=${WD}/android_lib
OPENCV_ROOT=${ANDROID_LIB_ROOT}/opencv/sdk/native/jni
PROTOBUF_ROOT=${ANDROID_LIB_ROOT}/protobuf
GFLAGS_HOME=${ANDROID_LIB_ROOT}/gflags
BOOST_HOME=${ANDROID_LIB_ROOT}/boost
OPENCL_ROOT=${ANDROID_LIB_ROOT}/opencl/1.2
OPENBLAS_ROOT=${WD}/android_lib/openblas-soft
VIENNACL_ROOT=${ANDROID_LIB_ROOT}/viennacl-hard
CLBLAS_ROOT=${ANDROID_LIB_ROOT}/clblas-hard
GLOG_ROOT=${ANDROID_LIB_ROOT}/glog
LMDB_ROOT=${ANDROID_LIB_ROOT}/lmdb
LEVELDB_ROOT=${ANDROID_LIB_ROOT}/leveldb
SNAPPY_ROOT=${ANDROID_LIB_ROOT}/snappy
DSPBLAS_HOME=${ANDROID_LIB_ROOT}/dspBLAS
UPR_ROOT=${ANDROID_LIB_ROOT}/upr
GEMMLOWP_ROOT=${WD}/gemmlowp

rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"


cmake -DCMAKE_TOOLCHAIN_FILE="${WD}/android-cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${NDK_ROOT}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_ABI="${ANDROID_ABI}" \
      -DANDROID_NATIVE_API_LEVEL=21 \
      -DADDITIONAL_FIND_PATH="${ANDROID_LIB_ROOT}" \
      -DANDROID_USE_OPENMP=OFF \
      -DBUILD_python=OFF \
      -DBUILD_docs=OFF \
      -DCPU_ONLY=OFF \
      -DUSE_CUDA=OFF \
      -DUSE_GREENTEA=ON \
      -DUSE_GLOG=ON \
      -DUSE_LMDB=ON \
      -DLMDB_INCLUDE_DIR="${LMDB_ROOT}/include" \
      -DLMDB_LIBRARIES="${LMDB_ROOT}/lib/liblmdb-dev.a" \
      -DUSE_LEVELDB=ON \
      -DLevelDB_INCLUDE="${LEVELDB_ROOT}/include" \
      -DLevelDB_LIBRARY="${LEVELDB_ROOT}/lib/libleveldb.a" \
      -DSnappy_INCLUDE_DIR="${SNAPPY_ROOT}/include" \
      -DSnappy_LIBRARIES="${SNAPPY_ROOT}/lib/libsnappy.a" \
      -DUSE_HDF5=OFF \
      -DVIENNACL_HOME=${VIENNACL_ROOT} \
      -DVIENNACL_WITH_OPENCL=1 \
      -DUSE_OPENBLAS=0 \
      -DOpenBLAS_INCLUDE_DIR=${OPENBLAS_ROOT}/include \
      -DOpenBLAS_LIB=${OPENBLAS_ROOT}/lib/libopenblas.a \
      -DUSE_CLBLAS=1 \
      -DCLBLAS_INCLUDE_DIR=${CLBLAS_ROOT}/include \
      -DCLBLAS_LIBRARY=${CLBLAS_ROOT}/lib/libclBLAS.so \
      -DUSE_DSPBLAS=1 \
      -DDSPBLAS_INCLUDE_DIR=${DSPBLAS_HOME}/include \
      -DDSPBLAS_LIBRARY=${DSPBLAS_HOME}/lib/libdspBLAS.so \
      -DUSE_UPR=0 \
      -DUPR_INCLUDE_DIR=${UPR_ROOT}/include \
      -DUPR_LIBRARY=${UPR_ROOT}/lib/libupr.so \
      -DUSE_GEMMLOWP=ON \
      -DGEMMLOWP_INCLUDE_DIR=${GEMMLOWP_ROOT} \
      -DBLAS="Open" \
      -DBOOST_ROOT="${BOOST_HOME}" \
      -DBoost_INCLUDE_DIR="${BOOST_HOME}/include" \
      -DBoost_LIBRARY_DIR="${BOOST_HOME}/lib" \
      -DGFLAGS_INCLUDE_DIR="${GFLAGS_HOME}/include" \
      -DGFLAGS_LIBRARY="${GFLAGS_HOME}/lib/libgflags_nothreads.a" \
      -DGLOG_INCLUDE_DIR="${GLOG_ROOT}/include" \
      -DGLOG_LIBRARY="${GLOG_ROOT}/lib/libglog.a" \
      -DOPENCL_INCLUDE_DIRS="${OPENCL_ROOT}" \
      -DOPENCL_LIBRARIES="${OPENCL_ROOT}/libOpenCL.so" \
      -DOpenCV_DIR="${OPENCV_ROOT}" \
      -DPROTOBUF_PROTOC_EXECUTABLE="/usr/local/bin/protoc" \
      -DGIT_EXECUTABLE=`which git` \
      -DPROTOBUF_INCLUDE_DIR="${PROTOBUF_ROOT}/include" \
      -DPROTOBUF_LIBRARY="${PROTOBUF_ROOT}/lib/libprotobuf.a" \
      -DCMAKE_INSTALL_PREFIX="${ANDROID_LIB_ROOT}/caffe" \
      ..


make -j${N_JOBS}
rm -rf "${ANDROID_LIB_ROOT}/caffe"
make install/strip

cd "${WD}"
