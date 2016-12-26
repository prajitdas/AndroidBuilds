#!/bin/bash
if [ -z $1 ]; then
	echo "device id? 'hammerhead'?"
else
	#Measure execution time
	start_time=`date +%s`
	adb reboot bootloader
	fastboot flash system out/target/product/$1/system.img
	fastboot reboot
	adb logcat | tee logcat.log
	end_time=`date +%s`
	echo execution time was `expr $end_time - $start_time` s.
fi
