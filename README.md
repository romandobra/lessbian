# Debian LiveCD toram. Skinny desktop with the latest drivers

It is less Debian - LESSBIAN.
Gnome desktop into live boot ISO. No bloatware. Fresh drivers.
Based on https://github.com/head-on-a-stick/newer-buster.

# How to boot Debian to RAM
## STEP 1:
Download the ISO from https://github.com/Head-on-a-Stick/newer-buster/releases.
## STEP 2:
Download this repo as .zip or _git clone_ it.
## STEP 3:
### Use the main script _`lessbian.sh`_ as root user:
> Before you begin, make directories `apt-cache` and `log`. This will allow you to use local cache if you want to build twice and more.
* _`lessbian.sh r`_ - to set or reset all needed assets _(It will make two directories `edit` and `iso`)_.
* _`lessbian.sh c`_ - to do chroot stuff. By default it will install _`google-chrome-stable`_ into your future ISO. If you want to disable Chrome or install your software, just modify the _`my-apps.sh`_ script accordingly.
* _`lessbian.sh t`_ - this will __prepare your iso to boot from RAM__ (_Feel free to edit the included _`grub.cfg`_ if you know what you are doing. The default grub config in the ISO will be overwritten with this file_).
* _`lessbian.sh p`_ - this will pack the finall ISO.
* _`lessbian.sh k`_ - to test your ISO with KVM (have to be installed).
* _`lessbian.sh d`_ - will clean up _(It won't delete the directories `apt-cache` and `log`. You have to remove them manually. Do this only if you are happy with your last build)_.
* _`lessbian.sh rctpdk`_ and any combinations also work fine!
## Step 4:
Enjoy and ...
# Give a star to this repo!
