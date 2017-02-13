#!/bin/bash
echo $PATH | grep "platform-tools" -q
if [ $? -eq 0 ]; then
	echo "We have ADB and FASTBOOT installed! On to the next step..."

	sudo apt-get install bc bison build-essential curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline6-dev lib32z1-dev libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk3.0-dev libxml2 libxml2-utils lzop pngcrush schedtool squashfs-tools xsltproc zip zlib1g-dev

	sudo apt-get install openjdk-8-jdk

	mkdir -p ~/bin
	mkdir -p ~/android/system
	mkdir -p ~/android/system/ccache

	curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
	chmod a+x ~/bin/repo

	echo $PATH | grep "platform-tools" -q
	if [ $? -eq 0 ]; then
		echo
		echo
		echo "Environment properly setup. Moving on..."
	else
		echo "Put the ~/bin directory in your path of execution
In recent versions of Ubuntu, ~/bin should already be in your PATH. You can check this by opening ~/.profile with a text editor and verifying the following code exists (add it if it is missing):

# set PATH so it includes user's private bin if it exists
if [ -d \"\$HOME/bin\" ] ; then
    PATH=\"\$HOME/bin:\$PATH\"
fi

Then, run source ~/.profile to update your environment."
		exit 0
	fi	
else
	echo "Please install the SDK: If you haven’t previously installed adb and fastboot, you can download them from Google (https://dl.google.com/android/repository/platform-tools-latest-linux.zip).
Extract it using: \"unzip platform-tools-latest-linux.zip -d ~\"
And then we have to add adb and fastboot to our path. Open ~/.profile and add the following:

# add Android SDK platform tools to path
if [ -d \"\$HOME/platform-tools\" ] ; then
    PATH=\"\$HOME/platform-tools:\$PATH\"
fi

Then, run source ~/.profile to update your environment."
fi
