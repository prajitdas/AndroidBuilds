#!/bin/bash
# Sample quick build for mako
device=`adb devices | awk '{if($2 == "device") print $1;}' | tr -d '\n'`
model=`adb -s $device shell getprop ro.product.model | tr -d '\n'`
date=`date +%Y%m%d | tr -d '\n'`
build="mako"
filename="lineage-14.1-"$date"-UNOFFICIAL-"$build".zip"
if [[ $model == 'Nexus 4' ]]; then
        #Measure execution time
        start_time=`date +%s`
        make clobber
        source build/envsetup.sh
        breakfast $build
        cd ~/android/$build-lineage-14.1-experimental-prajit/device/lge/$build
        ./extract-files.sh
        export USE_CCACHE=1
        croot
        prebuilts/misc/linux-x86/ccache/ccache -M 50G
        export ANDROID_JACK_VM_ARGS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4G"
        brunch $build
        cd $OUT
	if [[ -f "$filename" ]]; then
		adb push $filename /sdcard/
		adb reboot bootloader
	fi
        end_time=`date +%s`
        echo execution time was `expr $end_time - $start_time` s.
else
        echo "You have your $model device connected to the computer. This is a build process for the Nexus 4. Please connect your Nexus 4 device to the computer and restart the build."
fi
