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
### Use the main script _`lessbian.sh`_ as root user:
> Before you begin, make directories _apt-cache_ and _log_. This will allow you to use local cache if you want to build twice and more.
* _`lessbian.sh r`_ - to set or reset all needed assets. It will make two directories _edit_ and _iso_.
* _`lessbian.sh c`_ - to do chroot stuff. By default it will install _google-chrome-stable_ into your future ISO. If you want to disable Chrome or install your software, just modify the _`my-apps.sh`_ script accordingly.
* _`lessbian.sh t`_ - this will __prepare your iso to boot from RAM__.
* _`lessbian.sh p`_ - this will pack the finall ISO.
* _`lessbian.sh k`_ - to test your ISO with KVM (have to be installed).
* _`lessbian.sh d`_ - will clean up. It won't delete the directories with _apt-cache_ and _log_. You have to remove them manually. Do this only if you are happy with your last build.
* _`lessbian.sh rctpdk`_ and any combinations also work fine!
## Step 4:
Enjoy and ...
# Give a star to this repo!
