#!/bin/bash
# Sample quick-build for a mako device
device=`adb devices | awk '{if($2 == "device") print $1;}' | tr -d '\n'`
model=`adb -s $device shell getprop ro.product.model | tr -d '\n'`
if [[ $model == 'Nexus 4' ]]; then
	#Measure execution time
	start_time=`date +%s`
	make clobber
	source build/envsetup.sh
	breakfast mako
	cd ~/android/mako-lineage-14.1-experimental-prajit/device/lge/mako
	./extract-files.sh
	export USE_CCACHE=1
	croot
	prebuilts/misc/linux-x86/ccache/ccache -M 50G
	export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"
	brunch mako
	cd $OUT
	#adb push lineage-14.1-20170208-UNOFFICIAL-mako.zip /sdcard/
	end_time=`date +%s`
	echo execution time was `expr $end_time - $start_time` s.
else
	echo "You have your $model device connected to the computer. This is a build process for the Nexus 4. Please connect your Nexus 4 device to the computer and restart the build."
fi
