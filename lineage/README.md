Android builds
==============

This project will allow users to build custom Lineage OS ROMs. Smaple instructions for building mako (Nexus 4), from Lineage are available [here](http://wiki.lineageos.org/mako_build.html). 

### Run instructions
The scripts and steps listed will require device info, i.e. 'hammerhead'.

1. Setup the build environment for your OS version. (This script assumes Ubuntu 16.04 LTS)

  ```{r, engine='bash', count_lines}
    ./env-setup.sh
  ```

2. Initiate repo for AOSP build for a particular device. 

  ```{r, engine='bash', count_lines}
    ./init-lineage-device-build.sh deviceName
  ```

3. Install image on device.

   The two files we’re interested in are:
   * `recovery.img`, which is the LineageOS recovery image.
   * `lineage-14.1-20170213-UNOFFICIAL-mako.zip`, which is the LineageOS installer package.

  Go to the OUT folder as shown below and push the files on to your phone via connected USB and use a custom recovery like TWRP to isntall the new ROM you just built.
  ```{r, engine='bash', count_lines}
    cd $OUT
    adb push filename /sdcard/
    adb reboot bootloader
  ```

## Restoring devices to factory state
Factory images for Nexus 5, Nexus 10, Nexus 4, Nexus Q, Nexus 7, Galaxy Nexus (GSM/HSPA+ "yakju" and "takju", and CDMA/LTE "mysid" and "mysidspr"), Nexus S, and Nexus S 4G are available from [Google's factory image page](https://developers.google.com/android/nexus/images).

Factory images for the Motorola Xoom are distributed directly by Motorola.
