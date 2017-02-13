#!/bin/bash
if [ -z $1 ]; then
	echo "Usage: ./env-setup.sh username"
	echo "We need the user name for setting the permissions."
else
	release=`lsb_release -a | grep Release | cut -f2 -d ":" | tr -d '\t'`
	echo "	Initializing Build Environment
			Installing the JDK
			The master branch of Android in the Android Open Source Project (AOSP) requires Java 7. On Ubuntu, use OpenJDK.
			Java 7: For the latest version of Android"
	sudo apt-get update
	if [ $release=='12.04' ]; then
		echo "	Installing required packages (Ubuntu 12.04)
				You will need a 64-bit version of Ubuntu. Ubuntu 12.04 is recommended. Building using an older version of Ubuntu is not supported on master or recent releases."
		sudo apt-get install openjdk-7-jdk
		sudo apt-get install git gnupg flex bison gperf build-essential \
		zip curl libc6-dev libncurses5-dev:i386 x11proto-core-dev \
		libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-glx:i386 \
		libgl1-mesa-dev g++-multilib mingw32 tofrodos \
		python-markdown libxml2-utils xsltproc zlib1g-dev:i386
		sudo ln -s /usr/lib/i386-linux-gnu/mesa/libGL.so.1 /usr/lib/i386-linux-gnu/libGL.so				
	elif [[ $release == *'14.04'* ]]; then
		echo "	Installing required packages (Ubuntu 14.04)
				Building on Ubuntu 14.04 is experimental at the moment but will eventually become the recommended environment."
		sudo apt-get install openjdk-7-jdk
		sudo apt-get install bison g++-multilib git gperf libxml2-utils zip curl git-core gnupg flex bison gperf build-essential
	elif [[ $release == *'15.04'* ]]; then
		echo "	Installing required packages (Ubuntu 15.04)
				Building on Ubuntu 15.04 is experimental at the moment but will eventually become the recommended environment."
		sudo apt-get install openjdk-8-jdk
		sudo apt-get install bison g++-multilib git gperf libxml2-utils zip curl git-core gnupg flex bison gperf build-essential
	elif [[ $release == *'16.04'* ]]; then
		echo "	Installing required packages (Ubuntu 16.04)
				Building on Ubuntu 16.04 is experimental at the moment but will eventually become the recommended environment."
		sudo apt-get install openjdk-8-jdk
		sudo apt-get install bison g++-multilib git gperf libxml2-utils zip curl git-core gnupg flex bison gperf build-essential
	else
		echo "	Installing required packages (Ubuntu 10.04 -- 11.10)
				Building on Ubuntu 10.04-11.10 is no longer supported, but may be useful for building older releases of AOSP."
		sudo apt-get install openjdk-7-jdk
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
	echo "Optionally, update the default Java version by running:"
	sudo update-alternatives --config java
	sudo update-alternatives --config javac
	echo "	Configuring USB Access
			Under GNU/linux systems (and specifically under Ubuntu systems), regular users can't directly access USB devices by default. The system needs to be configured to allow such access.
			The recommended approach is to create a file /etc/udev/rules.d/51-android.rules (as the root user) and to copy the following lines in it. <username> must be replaced by the actual username of the user who is authorized to access the phones over USB."
	wget -S -O - http://source.android.com/source/51-android.rules | sed "s/<username>/$1/" | sudo tee >/dev/null /etc/udev/rules.d/51-android.rules; sudo udevadm control --reload-rules
fi
