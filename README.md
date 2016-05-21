## raspi-crashplan
Script for installing CrashPlan on Raspberry Pi
Tested on Raspberry Pi 3 Model B, running Raspbian "Jessie", with CrashPlan 4.7.0

Searching for "Raspberry Pi CrashPlan" I found many articles for CrashPlan 3, on older Raspbian distributions, but nothing current.
I mostly followed the instructions at  http://www.jonrogers.co.uk/2012/05/crashplan-on-the-raspberry-pi/ but 
had to do some things differently to make it work.  Having multiple RPi's to install this on, i wanted something
repeatable so created this script to do everything.

This seems to work for me, and may work for you, but the configuration is not supported by Code42.  As noted at https://support.code42.com/CrashPlan/4/Configuring/Beyond_The_Code_Unsupported_CrashPlan_Configurations:
>ARM devices do not meet the CrashPlan app's processor requirements. Raspberry Pi, Pogoplug, and other systems using ARM architecture may be able to run CrashPlan, but the configuration is unsupported. Your results may vary.

Other than the libjtux.so (downloaded from the link provided on Jon Rogers' page above), and the CrashPlan Linux software (downloaded from www.code42.com), this uses standard packages installed by apt-get.  All of the scripted adjustments happen inside the crashplan install directory, so you won't be tainting your overall distribution by doing this.

####Summary of script actions:
- Download and unpack CrashPlan Linux tarball
- Modify install.sh to use Raspbian's oracle java instead of downloading own
- Run the installer
- Remove the x86 .so files from install directory
- Download prebuilt libjtux.so (from Jon Rogers blog)
- Install packages via apt-get: libjna-java libswt-gtk-4-java libswt-cairo-gtk-4-jni
- Replace CrashPlan's swt.jar with a link to the one from libswt-gtk-4-java
