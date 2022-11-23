# Lessbian - Debian LiveCD toram
The power of Debian. Nothing more. Less Debian - LESSBIAN.
Gnome desktop into live boot ISO. No bloatware. Fresh drivers.

## Motivation:
I wanted a Linux system that:
- can install all the recent software, but
- has as few preinstalled software as possible 
- can easily boot from USB
- can boot to the RAM.

## It consists of two main parts:
- `base.sh` script
- `install.sh` script.

### Base
This script will download and make an archive of current stable Debian distribution in two "versions" - one is without the X server and the other is with it. You can choose the version during the `install.sh` run. This script is using Debian debootstrap and chroot to download and make the base archive. X server version is using Gnome desktop, but this behavior is easy to change. You don't need this script if you want to install the basic Debian system.

### Install
This script will perform the actual installation to your drive. Please note that __your drive has to be formatted and the boot flag has to be set__ if you are going to actually boot from it.

Before the installation the script will ask you which version you want (x or nox) and download the appropriate archive from GitHub. 

Also it will download all the "parts" scripts to install to your new system ("custom" scripts). You are free to inspect those scripts and include/exclude any of the software as needed, make other changes to be performed. These parts will be executed in the chroot environment of your new install. Please review those scripts!

One of the "parts" will install the "overlay" script. Read about it here: https://github.com/romandobra/stateless-debian. This will help to boot to the RAM in a couple of different ways and to choose the way at boot if desired.

Each time Lessbian boots "like new". This happens because all the changes during the run are made in RAM. So if you have booted and installed any software, changed settings and so on, the next time Lessbian boots, all your changes are gone. This is intentional. If you want to change anything permanently you have to make it in the overlay files or during the"normal" boot. Read about the overlay script here: https://github.com/romandobra/stateless-debian.

## Known limitations:
The version with the X server uses the current user to perform all the changes in chroot. So your current system won't let you cleanly unmount the drive after the installation. Reboot will help.

Some tweaking is needed if you want the right drivers for your Nvidia video card. I think I made it to work by booting to the normal mode and installing the drivers as usual.

## Todo:
The system works just fine, but it can be better. If you can help me to exclude any unnecessary software by making changes to the parts scripts, please make a pull request. If someone can help to fix the installation of Nvidia drivers from the chroot, you are very welcome. Code reformatting would be great too! Actually any feedback is much appreciated.

This is how to use it in one line (you need to be root):
- `. <(wget -O - https://raw.githubusercontent.com/romandobra/lessbian/main/install.sh)`

Here is the first attempt to make such system:
* [v 1.1](https://github.com/romandobra/lessbian/tree/1.1)

Enjoy and ...
# Give a star to this repo!
