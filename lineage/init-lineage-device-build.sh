#!/bin/bash
if [ -z $1 ]; then
	echo "Usage: ./init-lineage-device-build.sh deviceName"
	echo "We need the device info. Is it 'hammerhead' or something else?"
else
	cd ~/android/system

	repo init -u https://github.com/LineageOS/android.git -b cm-14.1
	repo sync

	source build/envsetup.sh
	breakfast $1

	cd ~/android/system/device/lge/$1
	./extract-files.sh

	cd ~/android/system
	export USE_CCACHE=1
	export CCACHE_DIR=ccache
	prebuilts/misc/linux-x86/ccache/ccache -M 100G

	export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"

	croot

	#Measure execution time
	start_time=`date +%s`
	brunch $1 | tee build.log 
	end_time=`date +%s`

	echo execution time was `expr $end_time - $start_time` s.	
fi

#!/bin/bash
#if [ -z $1 ]; then
#	echo "Usage: ./install-device-sysimage.sh deviceInfo"
#	echo "device info? 'hammerhead'?"
#else
#	#Measure execution time
#	start_time=`date +%s`
#	adb reboot bootloader
#	fastboot flash system out/target/product/$1/system.img
#	fastboot reboot
#	adb logcat | tee logcat.log
#	end_time=`date +%s`
#	echo execution time was `expr $end_time - $start_time` s.
#fi
