#!/bin/bash
# This is a simple script that installs CrashPlan (from https://www.code42.com)
# on a Raspberry Pi (3 at least) running Raspbian "Jessie".
#
# Summary of steps:
# - Download and unpack CrashPlan Linux tarball
# - Modify install.sh to use Raspbian's oracle java instead of downloading own
# - Run the installer
# - Remove the x86 .so files from install directory
# - Download prebuilt libjtux.so (from Jon Rogers blog)
# - Install packages: libjna-java libswt-gtk-4-java libswt-cairo-gtk-4-jni
# - Replace CrashPlan's swt.jar with a link to the one from libswt-gtk-4-java

# Change this for new versions, but this is the version i've tested
CP=CrashPlan_4.7.0_Linux.tgz
# Change this if you want to install somewhere else, probably should be a
# command line option
TARGET=/usr/local/crashplan

# Use /tmp for temporary files... probably should check for free space
cd /tmp
if [ ! -f $CP ]; then
  echo "downloading crashplan from https://download.code42.com/installs/linux/install/CrashPlan/$CP"
  wget https://download.code42.com/installs/linux/install/CrashPlan/$CP
fi

echo "unpacking $CP"
tar xzf $CP

cd crashplan-install
JAVA=`ls /usr/lib/jvm/jdk*/bin/java`
echo "existing java is at $JAVA"
echo "removing JRE download from install.sh"
mv install.sh install.sh.orig
sed "s|^JAVACOMMON=\"DOWNLOAD\"|JAVACOMMON=\"$JAVA\"|" install.sh.orig > install.sh
chmod 700 install.sh

echo "running install.sh"
sudo ./install.sh $TARGET

echo "removing these x86 files from crashplan installation"
ls -l $TARGET/*.so
sudo /bin/rm $TARGET/*.so

echo "downloading Jon Rogers libjtux.so - see http://www.jonrogers.co.uk/2012/05/crashplan-on-the-raspberry-pi/"
cd /tmp
wget "http://www.jonrogers.co.uk/wp-content/uploads/2012/05/libjtux.so"
sudo mv libjtux.so $TARGET


echo "installing libjna-java"
sudo apt-get install libjna-java libswt-gtk-4-java libswt-cairo-gtk-4-jni

SWT=`ls /usr/lib/java/swt*`
echo "replacing $TARGET/lib/swt.jar with link to $SWT"
sudo mv $TARGET/lib/swt.jar $TARGET/lib/swt.tar.orig
sudo ln -s $SWT $TARGET/lib/swt.jar
