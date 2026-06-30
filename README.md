# Lessbian - Less Debian

The power of Debian. Nothing more. Less Debian - LESSBIAN.
Gnome desktop, live boot. No bloatware. Fresh drivers.

## Motivation:

I wanted a Debian system that:

- can install all the recent software, but
- has as few preinstalled software as possible
- can easily boot from USB
- can boot to the RAM.

## How it works

### `build-base.sh`
Needs LESSBIAN_MNT var to be set. This folder will be used to download distro and install all base sofware. Outputs .tar.gz archives to `_base/DISTRO/` at each step:
1. debootstrap (`data/base/steps/common/1`)
2. prepare (`data/base/steps/chroot/1-pre-DISTRO.sh`)
3. NOX (cli install)
4. X (GUI install).

It is safe to cleanup LESSBIAN_MNT after this script finishes. Also it's ok to `mount $LESSBIAN_DEV $LESSBIAN_MNT` before running this script, and don't clean it at all. This way you will skip the unpacking step in `build-install.sh`.

### `build-install.sh`
Needs LESSBIAN_MNT and LESSBIAN_DEV to be set. Will give you some hints with the exclamation mark during run. It's ok to run it multiple times. Outputs install scripts to `_install/`. When it's done, nothing is happened to your drive yet (except when it asks to unpack the base if mounted drive is empty). After that you should inspect the `_install/chroot_prepare.sh` script to see what will be installed. When you run `_install/run.sh`, it will install all the chosen software.

### `functions.sh`
Used in both scripts.

### What to be aware of
0. <span style="color:red">CHECK ALL SCRIPTS BEFORE RUNNING!</span>
1. Run from the root user (`sudo -i`). The order:
- `./build-base.sh`
- `./build-install.sh`
- `./_install/run.sh`
- `rm -rf _base _install`
2. LESSBIAN_DEV should be a partition device (like `sdb1`, not `/dev/sdb1`, not `sdb`).
3. You have to cleanup your drive and set the boot flag manually.
4. Overlay is configured to run from RAM by default (`data/install/b-overlay.sh`).
5. If you choose GUI apps, you better unpack `X.tar.gz` instaead of `NOX.tar.gz`.
6. After running `_install/run.sh` it's safe to delete `_base/` and `_install/`.

## Progress since simplify

1. Base builds for trixie, bullseye and bookworm
2. Install script

<hr>

Enjoy and ...

# Give a star to this repo!
