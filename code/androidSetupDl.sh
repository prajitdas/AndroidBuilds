#!/bin/bash
if [ -z $1 ]; then
	echo "Usage: ./androidSourceBuild.sh userId androidBuildBranchInfo deviceInfo"
	echo "We need the user id for setting the permissions."
else
	if [ -z $2 ]; then
		echo "We need the branch info. Is it 'android-4.0.1_r1' or something else?"
	else
		if [ -z $3 ]; then
			echo "We need the device info. Is it 'hammerhead' or something else?"
		else
			release=`lsb_release -a | grep Release | cut -f2 -d ":" | tr -d '\t'`
			echo "	Initializing Build Environment
					Installing the JDK
					The master branch of Android in the Android Open Source Project (AOSP) requires Java 7. On Ubuntu, use OpenJDK.
					Java 7: For the latest version of Android"
			sudo apt-get update
			sudo apt-get install openjdk-7-jdk
			echo "Optionally, update the default Java version by running:"
			sudo update-alternatives --config java
			sudo update-alternatives --config javac
			if [ $release=='12.04' ]; then
				echo "	Installing required packages (Ubuntu 12.04)
						You will need a 64-bit version of Ubuntu. Ubuntu 12.04 is recommended. Building using an older version of Ubuntu is not supported on master or recent releases."
				sudo apt-get install git gnupg flex bison gperf build-essential \
				zip curl libc6-dev libncurses5-dev:i386 x11proto-core-dev \
				libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-glx:i386 \
				libgl1-mesa-dev g++-multilib mingw32 tofrodos \
				python-markdown libxml2-utils xsltproc zlib1g-dev:i386
				sudo ln -s /usr/lib/i386-linux-gnu/mesa/libGL.so.1 /usr/lib/i386-linux-gnu/libGL.so
			elif [[ $release == *'14.04'* ]]; then
				echo "	Installing required packages (Ubuntu 14.04)
						Building on Ubuntu 14.04 is experimental at the moment but will eventually become the recommended environment."
				sudo apt-get install bison g++-multilib git gperf libxml2-utils zip curl git-core gnupg flex bison gperf build-essential
			elif [[ $release == *'15.04'* ]]; then
				echo "	Installing required packages (Ubuntu 15.04)
						Building on Ubuntu 15.04 is experimental at the moment but will eventually become the recommended environment."
				sudo apt-get install bison g++-multilib git gperf libxml2-utils zip curl git-core gnupg flex bison gperf build-essential
			else
				echo "	Installing required packages (Ubuntu 10.04 -- 11.10)
						Building on Ubuntu 10.04-11.10 is no longer supported, but may be useful for building older releases of AOSP."
				sudo apt-get install git-core gnupg flex bison gperf build-essential \
				zip curl zlib1g-dev libc6-dev lib32ncurses5-dev ia32-libs \
				x11proto-core-dev libx11-dev lib32readline5-dev lib32z-dev \
				libgl1-mesa-dev g++-multilib mingw32 tofrodos python-markdown \
				libxml2-utils xsltproc
				if [ $release=='11.10' ]; then
					sudo apt-get install libx11-dev:i386
				else
					sudo ln -s /usr/lib32/mesa/libGL.so.1 /usr/lib32/mesa/libGL.so
				fi
			fi
			echo "	Configuring USB Access
					Under GNU/linux systems (and specifically under Ubuntu systems), regular users can't directly access USB devices by default. The system needs to be configured to allow such access.
					The recommended approach is to create a file /etc/udev/rules.d/51-android.rules (as the root user) and to copy the following lines in it. <username> must be replaced by the actual username of the user who is authorized to access the phones over USB."
			sudo echo '# adb protocol on passion (Nexus One)
			SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4e12", MODE="0600", OWNER="$1"
			# fastboot protocol on passion (Nexus One)
			SUBSYSTEM=="usb", ATTR{idVendor}=="0bb4", ATTR{idProduct}=="0fff", MODE="0600", OWNER="$1"
			# adb protocol on crespo/crespo4g (Nexus S)
			SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4e22", MODE="0600", OWNER="$1"
			# fastboot protocol on crespo/crespo4g (Nexus S)
			SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4e20", MODE="0600", OWNER="$1"
			# adb protocol on stingray/wingray (Xoom)
			SUBSYSTEM=="usb", ATTR{idVendor}=="22b8", ATTR{idProduct}=="70a9", MODE="0600", OWNER="$1"
			# fastboot protocol on stingray/wingray (Xoom)
			SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="708c", MODE="0600", OWNER="$1"
			# adb protocol on maguro/toro (Galaxy Nexus)
			SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", ATTR{idProduct}=="6860", MODE="0600", OWNER="$1"
			# fastboot protocol on maguro/toro (Galaxy Nexus)
			SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4e30", MODE="0600", OWNER="$1"
			# adb protocol on panda (PandaBoard)
			SUBSYSTEM=="usb", ATTR{idVendor}=="0451", ATTR{idProduct}=="d101", MODE="0600", OWNER="$1"
			# adb protocol on panda (PandaBoard ES)
			SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="d002", MODE="0600", OWNER="$1"
			# fastboot protocol on panda (PandaBoard)
			SUBSYSTEM=="usb", ATTR{idVendor}=="0451", ATTR{idProduct}=="d022", MODE="0600", OWNER="$1"
			# usbboot protocol on panda (PandaBoard)
			SUBSYSTEM=="usb", ATTR{idVendor}=="0451", ATTR{idProduct}=="d00f", MODE="0600", OWNER="$1"
			# usbboot protocol on panda (PandaBoard ES)
			SUBSYSTEM=="usb", ATTR{idVendor}=="0451", ATTR{idProduct}=="d010", MODE="0600", OWNER="$1"
			# adb protocol on grouper/tilapia (Nexus 7)
			SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4e42", MODE="0600", OWNER="$1"
			# fastboot protocol on grouper/tilapia (Nexus 7)
			SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4e40", MODE="0600", OWNER="$1"
			# adb protocol on manta (Nexus 10)
			SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee2", MODE="0600", OWNER="$1"
			# fastboot protocol on manta (Nexus 10)
			SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", ATTR{idProduct}=="4ee0", MODE="0600", OWNER="$1"' > /etc/udev/rules.d/51-android.rules
			sudo $1

			# echo "	Using a separate output directory
			#		By default, the output of each build is stored in the out/ subdirectory of the matching source tree.
			#		On some machines with multiple storage devices, builds are faster when storing the source files and the output on separate volumes. For additional performance, the output can be stored on a filesystem optimized for speed instead of crash robustness, since all files can be re-generated in case of filesystem corruption.
			#		To set this up, export the OUT_DIR_COMMON_BASE variable to point to the location where your output directories will be stored.
			#		The output directory for each separate source tree will be named after the directory holding the source tree.
			#		For instance, if you have source trees as /source/master1 and /source/master2 and OUT_DIR_COMMON_BASE is set to /output, the output directories will be /output/master1 and /output/master2.
			#		It's important in that case to not have multiple source trees stored in directories that have the same name, as those would end up sharing an output directory, with unpredictable results.
			#		This is only supported on Jelly Bean (4.1) and newer, including the master branch."
			# export OUT_DIR_COMMON_BASE=~/workingFolder/AndroidBuilds/builds/$2/out
			
			# For build tags llok at https://source.android.com/source/build-numbers.html
			# Downloading the source
			# Build	Branch	Version	Supported devices
			# MXC89L 	android-6.0.1_r63 	Marshmallow 	Pixel C
			# MTC20F 	android-6.0.1_r62 	Marshmallow 	Nexus 5X, Nexus 6P
			# MOB30Y 	android-6.0.1_r60 	Marshmallow 	Nexus 5
			# MOB30X 	android-6.0.1_r59 	Marshmallow 	Nexus 7 (flo/deb)
			# MOB30W 	android-6.0.1_r58 	Marshmallow 	Nexus 6, Nexus 9 (volantis/volantisg), Nexus Player
			# MMB30S 	android-6.0.1_r57 	Marshmallow 	Nexus 7 (deb)
			# MMB30R 	android-6.0.1_r56 	Marshmallow 	Nexus 6
			# MXC89K 	android-6.0.1_r55 	Marshmallow 	Pixel C
			# MTC19Z 	android-6.0.1_r54 	Marshmallow 	Nexus 5X
			# MTC19X 	android-6.0.1_r53 	Marshmallow 	Nexus 6P
			# MOB30P 	android-6.0.1_r50 	Marshmallow 	Nexus 5, Nexus 7 (flo/deb), Nexus 9 (volantis/volantisg), Nexus Player
			# MOB30O 	android-6.0.1_r49 	Marshmallow 	Nexus 6
			# MMB30M 	android-6.0.1_r48 	Marshmallow 	Nexus 7 (deb)
			# MMB30K 	android-6.0.1_r47 	Marshmallow 	Nexus 6
			# MOB30M 	android-6.0.1_r46 	Marshmallow 	Nexus 5, Nexus 6, Nexus 7 (flo/deb), Nexus 9 (volantis/volantisg), Nexus Player
			# MTC19V 	android-6.0.1_r45 	Marshmallow 	Nexus 5X, Nexus 6P
			# MOB30J 	android-6.0.1_r43 	Marshmallow 	Nexus 7 (flo/deb)
			# MOB30I 	android-6.0.1_r42 	Marshmallow 	Nexus 6
			# MOB30H 	android-6.0.1_r41 	Marshmallow 	Nexus 5
			# MOB30G 	android-6.0.1_r40 	Marshmallow 	Nexus 9 (volantis/volantisg), Nexus Player
			# MXC89H 	android-6.0.1_r33 	Marshmallow 	Pixel C
			# MXC89F 	android-6.0.1_r32 	Marshmallow 	Pixel C
			# MMB30J 	android-6.0.1_r28 	Marshmallow 	Nexus 6, Nexus 7 (deb)
			# MTC19T 	android-6.0.1_r25 	Marshmallow 	Nexus 5X, Nexus 6P
			# M5C14J 	android-6.0.1_r31 	Marshmallow 	Pixel C
			# MOB30D 	android-6.0.1_r30 	Marshmallow 	Nexus 5, Nexus 6, Nexus 7 (flo/deb), Nexus 9 (volantis/volantisg), Nexus Player
			# MHC19Q 	android-6.0.1_r24 	Marshmallow 	Nexus 5X, Nexus 6P
			# MHC19J	android-6.0.1_r22	Marshmallow	Nexus 5X
			# MXC14G	android-6.0.1_r18	Marshmallow	Pixel C
			# MMB29V	android-6.0.1_r17	Marshmallow	Nexus 5, Nexus 5X, Nexus 6, Nexus 6P, Nexus 7 (flo/deb), Nexus 9 (volantis/volantisg)
			# MXB48T	android-6.0.1_r16	Marshmallow	Pixel C
			# MMB29U	android-6.0.1_r13	Marshmallow	Nexus Player
			# MMB29R	android-6.0.1_r12	Marshmallow	Nexus 9 (volantis/volantisg)
			# MMB29Q	android-6.0.1_r11	Marshmallow	Nexus 5, Nexus 5X, Nexus 6, Nexus 6P, Nexus 7 (flo/deb)
			# MMB29T	android-6.0.1_r10	Marshmallow	Nexus Player
			# MMB29S	android-6.0.1_r9	Marshmallow	Nexus 5, Nexus 6, Nexus 9 (volantis/volantisg)
			# MMB29P	android-6.0.1_r8	Marshmallow	Nexus 5X, Nexus 6P
			# MMB29O	android-6.0.1_r7	Marshmallow	Nexus 7 (flo/deb)
			# MXB48K	android-6.0.1_r5	Marshmallow	Pixel C
			# MXB48J	android-6.0.1_r4	Marshmallow	Pixel C
			# MMB29M	android-6.0.1_r3	Marshmallow	Nexus 6P, Nexus Player
			# MMB29K	android-6.0.1_r1	Marshmallow	Nexus 5, Nexus 5X, Nexus 6, Nexus 7 (flo/deb), Nexus 9 (volantis/volantisg)
			# MMB29N	android-6.0.0_r41	Marshmallow	Nexus 6P
			# MDB08M	android-6.0.0_r26	Marshmallow	Nexus 5X, Nexus 6P
			# MDB08L	android-6.0.0_r25	Marshmallow	Nexus 5X, Nexus 6P
			# MDB08K	android-6.0.0_r24	Marshmallow	Nexus 6P
			# MDB08I	android-6.0.0_r23	Marshmallow	Nexus 5X
			# MDA89E	android-6.0.0_r12	Marshmallow	Nexus 5X
			# MDA89D	android-6.0.0_r11	Marshmallow	Nexus 6P
			# MRA58V	android-6.0.0_r5	Marshmallow	Nexus 7 (flo/deb)
			# MRA58U	android-6.0.0_r4	Marshmallow	Nexus 7 (flo)
			# MRA58N	android-6.0.0_r2	Marshmallow	Nexus 5, Nexus 6, Nexus 7 (flo/deb), Nexus 9 (volantis/volantisg), Nexus Player
			# MRA58K	android-6.0.0_r1	Marshmallow	Nexus 5, Nexus 6, Nexus 7 (flo/deb), Nexus 9 (volantis/volantisg), Nexus Player
			# LMY48W	android-5.1.1_r24	Lollipop	Nexus 6
			# LVY48H	android-5.1.1_r23	Lollipop	Nexus 6 (For Project Fi ONLY)
			# LYZ28M	android-5.1.1_r22	Lollipop	Nexus 6 (For T-Mobile ONLY)
			# LMY48U	android-5.1.1_r20	Lollipop	Nexus 7 (deb)
			# LMY48T	android-5.1.1_r19	Lollipop	Nexus 4, Nexus 6, Nexus 9 (volantis/volantisg), Nexus 10
			# LVY48F	android-5.1.1_r18	Lollipop	Nexus 6 (For Project Fi ONLY)
			# LYZ28K	android-5.1.1_r17	Lollipop	Nexus 6 (For T-Mobile ONLY)
			# LMY48P	android-5.1.1_r16	Lollipop	Nexus 7 (deb)
			# LMY48N	android-5.1.1_r15	Lollipop	Nexus Player
			# LMY48M	android-5.1.1_r14	Lollipop	Nexus 4, Nexus 5, Nexus 6, Nexus 7 (flo), Nexus 9 (volantis/volantisg), Nexus 10
			# LVY48E	android-5.1.1_r13	Lollipop	Nexus 6 (For Project Fi ONLY)
			# LYZ28J	android-5.1.1_r12	Lollipop	Nexus 6 (For T-Mobile ONLY)
			# LMY48J	android-5.1.1_r10	Lollipop	Nexus Player
			# LMY48I	android-5.1.1_r9	Lollipop	Nexus 4, Nexus 5, Nexus 6, Nexus 7 (flo), Nexus 9 (volantis/volantisg), Nexus 10
			# LVY48C	android-5.1.1_r8	Lollipop	Nexus 6 (For Project Fi ONLY)
			# LMY48G	android-5.1.1_r6	Lollipop	Nexus 7 (flo)
			# LYZ28E	android-5.1.1_r5	Lollipop	Nexus 6 (For T-Mobile ONLY)
			# LMY47Z	android-5.1.1_r4	Lollipop	Nexus 6 (All carriers except T-Mobile US)
			# LMY48B	android-5.1.1_r3	Lollipop	Nexus 5
			# LMY47X	android-5.1.1_r2	Lollipop	Nexus 9 (volantis)
			# LMY47V	android-5.1.1_r1	Lollipop	Nexus 7 (flo/grouper), Nexus 10, Nexus Player
			# LMY47O	android-5.1.0_r5	Lollipop	Nexus 4, Nexus 7 (flo/deb)
			# LMY47M	android-5.1.0_r4	Lollipop	Nexus 6 (For T-Mobile ONLY)
			# LMY47I	android-5.1.0_r3	Lollipop	Nexus 5, Nexus 6
			# LMY47E	android-5.1.0_r2	Lollipop	Nexus 6
			# LMY47D	android-5.1.0_r1	Lollipop	Nexus 5, Nexus 6, Nexus 7 (grouper), Nexus 10
			# LRX22G	android-5.0.2_r1	Lollipop	Nexus 7 (flo/deb/grouper/tilapia), Nexus 10
			# LRX22C	android-5.0.1_r1	Lollipop	Nexus 4, Nexus 5, Nexus 6 (shamu), Nexus 7 (flo), Nexus 9 (volantis/volantisg), Nexus 10
			# LRX21V	android-5.0.0_r7.0.1	Lollipop	Nexus Player (fugu)
			# LRX21T	android-5.0.0_r6.0.1	Lollipop	Nexus 4
			# LRX21R	android-5.0.0_r5.1.0.1	Lollipop	Nexus 9 (volantis)
			# LRX21Q	android-5.0.0_r5.0.1	Lollipop	Nexus 9 (volantis)
			# LRX21P	android-5.0.0_r4.0.1	Lollipop	Nexus 7 (flo/grouper), Nexus 10
			# LRX21O	android-5.0.0_r3.0.1	Lollipop	Nexus 5 (hammerhead), Nexus 6 (shamu)
			# LRX21M	android-5.0.0_r2.0.1	Lollipop	Nexus Player (fugu)
			# LRX21L	android-5.0.0_r1.0.1	Lollipop	Nexus 9 (volantis)
			# KTU84Q	android-4.4.4_r2	KitKat	Nexus 5 (hammerhead) (For 2Degrees/NZ, Telstra/AUS and India ONLY)
			# KTU84P	android-4.4.4_r1	KitKat	Nexus 5, Nexus 7 (flo/deb/grouper/tilapia), Nexus 4, Nexus 10
			# KTU84M	android-4.4.3_r1.1	KitKat	Nexus 5 (hammerhead)
			# KTU84L	android-4.4.3_r1	KitKat	Nexus 7 (flo/deb/grouper/tilapia), Nexus 4, Nexus 10
			# KVT49L	android-4.4.2_r2	KitKat	Nexus 7 (deb Verizon)
			# KOT49H	android-4.4.2_r1	KitKat	Nexus 5, Nexus 7 (flo/deb/grouper/tilapia), Nexus 4, Nexus 10
			# KOT49E	android-4.4.1_r1	KitKat	Nexus 5, Nexus 7 (flo/deb/grouper/tilapia), Nexus 4, Nexus 10
			# KRT16S	android-4.4_r1.2	KitKat	Nexus 7 (flo/deb/grouper/tilapia), Nexus 4, Nexus 10
			# KRT16M	android-4.4_r1	KitKat	Nexus 5 (hammerhead)
			# JLS36I	android-4.3.1_r1	Jelly Bean	Nexus 7 (deb)
			# JLS36C	android-4.3_r3	Jelly Bean	Nexus 7 (deb)
			# JSS15R	android-4.3_r2.3	Jelly Bean	Nexus 7 (flo)
			# JSS15Q	android-4.3_r2.2	Jelly Bean	Nexus 7 (flo)
			# JSS15J	android-4.3_r2.1	Jelly Bean	Nexus 7 (flo/deb)
			# JSR78D	android-4.3_r2	Jelly Bean	Nexus 7 (deb)
			# JWR66Y	android-4.3_r1.1	Jelly Bean	Galaxy Nexus, Nexus 7 (grouper/tilapia), Nexus 4, Nexus 10
			# JWR66V	android-4.3_r1	Jelly Bean	Galaxy Nexus, Nexus 7 (grouper/tilapia), Nexus 4, Nexus 10
			# JWR66N	android-4.3_r0.9.1	Jelly Bean	Galaxy Nexus, Nexus 7 (grouper/tilapia/flo), Nexus 4, Nexus 10
			# JWR66L	android-4.3_r0.9	Jelly Bean	Nexus 7
			# JDQ39E	android-4.2.2_r1.2	Jelly Bean	Nexus 4
			# JDQ39B	android-4.2.2_r1.1	Jelly Bean	Nexus 7
			# JDQ39	android-4.2.2_r1	Jelly Bean	Galaxy Nexus, Nexus 7, Nexus 4, Nexus 10
			# JOP40G	android-4.2.1_r1.2	Jelly Bean	Nexus 4
			# JOP40F	android-4.2.1_r1.1	Jelly Bean	Nexus 10
			# JOP40D	android-4.2.1_r1	Jelly Bean	Galaxy Nexus, Nexus 7, Nexus 4, Nexus 10
			# JOP40C	android-4.2_r1	Jelly Bean	Galaxy Nexus, Nexus 7, Nexus 4, Nexus 10
			# JZO54M	android-4.1.2_r2.1	Jelly Bean	
			# JZO54L	android-4.1.2_r2	Jelly Bean	
			# JZO54K	android-4.1.2_r1	Jelly Bean	Nexus S, Galaxy Nexus, Nexus 7
			# JRO03S	android-4.1.1_r6.1	Jelly Bean	Nexus 7
			# JRO03R	android-4.1.1_r6	Jelly Bean	Nexus S 4G
			# JRO03O	android-4.1.1_r5	Jelly Bean	Galaxy Nexus
			# JRO03L	android-4.1.1_r4	Jelly Bean	Nexus S
			# JRO03H	android-4.1.1_r3	Jelly Bean	
			# JRO03E	android-4.1.1_r2	Jelly Bean	Nexus S
			# JRO03D	android-4.1.1_r1.1	Jelly Bean	Nexus 7
			# JRO03C	android-4.1.1_r1	Jelly Bean	Galaxy Nexus
			# IMM76L	android-4.0.4_r2.1	Ice Cream Sandwich	 
			# IMM76K	android-4.0.4_r2	Ice Cream Sandwich	Galaxy Nexus
			# IMM76I	android-4.0.4_r1.2	Ice Cream Sandwich	Galaxy Nexus
			# IMM76D	android-4.0.4_r1.1	Ice Cream Sandwich	Nexus S, Nexus S 4G, Galaxy Nexus
			# IMM76	android-4.0.4_r1	Ice Cream Sandwich	
			# IML77	android-4.0.3_r1.1	Ice Cream Sandwich	
			# IML74K	android-4.0.3_r1	Ice Cream Sandwich	Nexus S
			# ICL53F	android-4.0.2_r1	Ice Cream Sandwich	Galaxy Nexus
			# ITL41F	android-4.0.1_r1.2	Ice Cream Sandwich	Galaxy Nexus
			# ITL41D	android-4.0.1_r1.1	Ice Cream Sandwich	Galaxy Nexus
			# ITL41D	android-4.0.1_r1	Ice Cream Sandwich	Galaxy Nexus
			# GWK74	android-2.3.7_r1	Gingerbread	Nexus S 4G
			# GRK39F	android-2.3.6_r1	Gingerbread	Nexus One, Nexus S
			# GRK39C	android-2.3.6_r0.9	Gingerbread	Nexus S
			# GRJ90	android-2.3.5_r1	Gingerbread	Nexus S 4G
			# GRJ22	android-2.3.4_r1	Gingerbread	Nexus One, Nexus S, Nexus S 4G
			# GRJ06D	android-2.3.4_r0.9	Gingerbread	Nexus S 4G
			# GRI54	android-2.3.3_r1.1	Gingerbread	Nexus S
			# GRI40	android-2.3.3_r1	Gingerbread	Nexus One, Nexus S
			# GRH78C	android-2.3.2_r1	Gingerbread	Nexus S
			# GRH78	android-2.3.1_r1	Gingerbread	Nexus S
			# GRH55	android-2.3_r1	Gingerbread	earliest Gingerbread version, Nexus S
			# FRK76C	android-2.2.3_r2	Froyo	 
			# FRK76	android-2.2.3_r1	Froyo	
			# FRG83G	android-2.2.2_r1	Froyo	Nexus One
			# FRG83D	android-2.2.1_r2	Froyo	Nexus One
			# FRG83	android-2.2.1_r1	Froyo	Nexus One
			# FRG22D	android-2.2_r1.3	Froyo	
			# FRG01B	android-2.2_r1.2	Froyo	
			# FRF91	android-2.2_r1.1	Froyo	Nexus One
			# FRF85B	android-2.2_r1	Froyo	Nexus One
			# EPF21B	android-2.1_r2.1p2	Eclair	 
			# ESE81	android-2.1_r2.1s	Eclair	
			# EPE54B	android-2.1_r2.1p	Eclair	Nexus One
			# ERE27	android-2.1_r2	Eclair	Nexus One
			# ERD79	android-2.1_r1	Eclair	Nexus One
			# ESD56	android-2.0.1_r1	Eclair	
			# ESD20	android-2.0_r1	Eclair	 
			# DMD64	android-1.6_r1.5	Donut	 
			# DRD20	android-1.6_r1.4		
			# DRD08	android-1.6_r1.3		
			# DRC92	android-1.6_r1.2				
			mkdir ~/bin
			PATH=~/bin:$PATH
			sudo curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
			chmod a+x ~/bin/repo
			mkdir -p ../builds/$3/$2
			cd ../builds/$3/$2
			repo init -u https://android.googlesource.com/platform/manifest -b $2
			repo sync
	
			# echo "	Setting up ccache
			# 		You can optionally tell the build to use the ccache compilation tool. Ccache acts as a compiler cache that can be used to speed-up rebuilds. This works very well if you do 'make clean' often, or if you frequently switch between different build products.
			# 		Put the following in your .bashrc or equivalent.
			# 		By default the cache will be stored in ~/.ccache. If your home directory is on NFS or some other non-local filesystem, you will want to specify the directory in your .bashrc as well.
			# 		The suggested cache size is 50-100GB. You will need to run the following command once you have downloaded the source code:
			# 		When building Ice Cream Sandwich (4.0.x) or older, ccache is in a different location:
			# 		This setting is stored in the CCACHE_DIR and is persistent."
			# export USE_CCACHE=1
			# mkdir -p ../builds/$2/ccache
			# export CCACHE_DIR=../builds/$2/ccache
			# prebuilts/misc/linux-x86/ccache/ccache -M 50G
		
			# #Building the system
			# source build/envsetup.sh
			# lunch # use aosp_buildtag(mako for example)-eng for engineering build with root access and debugging tools
			# make -j4 # try to use -j16 for fast builds
		fi
	fi
fi
