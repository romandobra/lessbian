# Debian LiveCD toram. With the latest drivers

It is less Debian - LESSBIAN.
Gnome desktop into live boot ISO. No bloatware. Fresh drivers.
Based on https://github.com/head-on-a-stick/newer-buster.

# How to boot Debian to RAM
## STEP 1:
Download the ISO from https://github.com/Head-on-a-Stick/newer-buster/releases.
## STEP 2:
Download this repo as .zip or _git clone_ it.
## STEP 3:
Use the main script _lessbian.sh_ as root user:

Before you begin, make directories __apt-cache__ and __logs__. This will allow you to use local cache if you want to build twice and more.

_lessbian.sh r_ - to set or reset all needed assets. It will make two directories _edit_ and _iso_.

_lessbian.sh c_ - to do chroot stuff. By default it will install _google-chrome_ into your future ISO. If you want to disable Chrome or install your software, just modify the _my-apps.sh_ script accordingly.

_lessbian.sh t_ - this will __prepare your iso to boot from RAM__.

_lessbian.sh p_ - this will pack the finall ISO.

_lessbian.sh k_ - to test your ISO with KVM (have to be installed).

_lessbian.sh d_ - will clean up. It won't delete the directories with __apt-cache__ and __logs__. You have to remove them manually. Do this only if you are happy with your last build.

_lessbian.sh rctpdk_ and any combinations also work fine!

Enjoy and ...

# Give a star to this repo!
