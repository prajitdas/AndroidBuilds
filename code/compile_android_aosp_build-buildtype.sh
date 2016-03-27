#!/bin/bash
export USE_CCACHE=1
export CCACHE_DIR=ccache
prebuilts/misc/linux-x86/ccache/ccache -M 50G
#Measure execution time
start_time=`date +%s`
#Building the system
source build/envsetup.sh
lunch $1
make -j16 VERBOSE=1 | tee build.log
end_time=`date +%s`
echo execution time was `expr $end_time - $start_time` s.
