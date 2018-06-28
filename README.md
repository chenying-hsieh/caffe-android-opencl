Caffe-Android-Lib
===============
## Goal

Porting [caffe](https://github.com/BVLC/caffe) to android platform and use mobile GPU for computation.


## Compile

- You will need to use protobuf version 3.0.2 on your host PC

git submodule init
git submodule update
./build.sh

## Execution

1. Collect all shared libraries (.so files) in android_libs/
2. Push shared libraries and caffe to your Android device
3. Execute caffe 
e.g. LD_LIBRARY_PATH=/path_to_the_shared_libraries/caffe 
