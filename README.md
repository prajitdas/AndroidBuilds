Android builds
==============

This project will allow users to build custom Android ROMs. Detailed instructions are available [here](https://source.android.com/source/initializing.html).

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

3. Build the image for a particular device.

  ```{r, engine='bash', count_lines}
    bash code/build-for-device-aosp.sh userId androidBuildBranchInfo deviceInfo
  ```
4. Install image on device.

  ```{r, engine='bash', count_lines}
    bash code/install-device-sysimage.sh deviceInfo
  ```
