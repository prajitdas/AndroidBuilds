#!/bin/bash
echo "	Setting up ccache
				You can optionally tell the build to use the ccache compilation tool. Ccache acts as a compiler cache that can be used to speed-up rebuilds. This works very well if you do 'make clean' often, or if you frequently switch between different build products.
				Put the following in your .bashrc or equivalent.
				By default the cache will be stored in ~/.ccache. If your home directory is on NFS or some other non-local filesystem, you will want to specify the directory in your .bashrc as well.
				The suggested cache size is 50-100GB. You will need to run the following command once you have downloaded the source code:
				When building Ice Cream Sandwich (4.0.x) or older, ccache is in a different location:
				This setting is stored in the CCACHE_DIR and is persistent."
export USE_CCACHE=1
mkdir -p ../builds/$2/ccache
export CCACHE_DIR=ccache
prebuilts/misc/linux-x86/ccache/ccache -M 50G
#Measure execution time
start_time=`date +%s`
#Building the system
source build/envsetup.sh
lunch $1 # use aosp_buildtag(mako for example)-eng for engineering build with root access and debugging tools
make -j16 VERBOSE=1 | tee build.log # try to use -j16 for fast builds
end_time=`date +%s`
echo execution time was `expr $end_time - $start_time` s.
