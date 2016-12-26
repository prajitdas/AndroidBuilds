Android builds
==============

This project will allow users to build custom Android ROMs. This repo has been used to build ROMs for the Nexus line of devices. Other OEMs have not been tested. Detailed instructions from Google are available [here](https://source.android.com/source/initializing.html).

### Run instructions
The scripts and steps listed will require your username, Android branch that you are building, i.e. 'android-4.0.1_r1' and device info, i.e. 'hammerhead'. This project is there to assist you in building AOSP. I do not claim any responsibility for your built images, neither do I guarantee that this will not break your build or brick your device. If you have built AOSP before, you know that such a possiblity exists. Please follow the instructions here at your own risk.

1. Setup the build environment for your OS version. 

  ```{r, engine='bash', count_lines}
    bash code/env-setup.sh username
  ```

2. Initiate repo for AOSP build for a particular device. 

  ```{r, engine='bash', count_lines}
    bash code/init-aosp-device-build.sh username androidBuildBranchInfo deviceInfo
  ```

3. Obtain proprietary binaries: AOSP cannot be used from pure source code only and requires additional hardware-related proprietary libraries to run, such as for hardware graphics acceleration. You can download some of the binaries for the nexus and other Google devices [here](https://developers.google.com/android/drivers). A script has been provided here for convenience (run as instructecd below). You can download official binaries for the supported devices running tagged AOSP release branches from Google's Nexus driver page. These binaries add access to additional hardware capabilities with non-open source code. To instead build the AOSP master branch, use the Binaries Preview for Nexus Devices. When building the master branch for a device, use the binaries for the most recent numbered release or with the most recent date. Each set of binaries comes as a self-extracting script in a compressed archive. Uncompress each archive, run the included self-extracting script from the root of the source tree, then confirm that you agree to the terms of the enclosed license agreement. The binaries and their matching makefiles will be installed in the `vendor/` hierarchy of the source tree.
  
  ```python
    python downloadVendorBinaries.py deviceId
  ```
  
4. Build the image for a particular device.

  ```{r, engine='bash', count_lines}
    bash code/build-for-device-aosp.sh userId androidBuildBranchInfo deviceInfo
  ```

5. Install image on device.

  ```{r, engine='bash', count_lines}
    bash code/install-device-sysimage.sh deviceInfo
  ```

## Restoring devices to factory state
Factory images for Nexus 5, Nexus 10, Nexus 4, Nexus Q, Nexus 7, Galaxy Nexus (GSM/HSPA+ "yakju" and "takju", and CDMA/LTE "mysid" and "mysidspr"), Nexus S, and Nexus S 4G are available from [Google's factory image page](https://developers.google.com/android/nexus/images).

Factory images for the Motorola Xoom are distributed directly by Motorola.
