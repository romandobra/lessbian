#!/usr/bin/env bash

set -e
(debootstrap --help; wget --help; chroot --help) > /dev/null

#LESSBIAN_DIST=bullseye; LESSBIAN_NF_COMPONENT="non-free"
LESSBIAN_DIST=bookworm; LESSBIAN_NF_COMPONENT="non-free non-free-firmware"

LESSBIAN_COMPONENTS="main contrib $LESSBIAN_NF_COMPONENT"

MNT="$(date +%s)-$LESSBIAN_DIST"; mkdir -p $MNT

debootstrap --arch amd64 $LESSBIAN_DIST $MNT https://deb.debian.org/debian/

echo "deb https://deb.debian.org/debian $LESSBIAN_DIST $LESSBIAN_COMPONENTS
deb-src https://deb.debian.org/debian $LESSBIAN_DIST $LESSBIAN_COMPONENTS
deb https://deb.debian.org/debian $LESSBIAN_DIST-updates $LESSBIAN_COMPONENTS
deb-src https://deb.debian.org/debian $LESSBIAN_DIST-updates $LESSBIAN_COMPONENTS
deb https://security.debian.org/debian-security $LESSBIAN_DIST-security main
" > $MNT/etc/apt/sources.list

function _build(){
  cat - > $MNT/_script
  mount -B /dev $MNT/dev; mount -t proc /proc $MNT/proc; mount -t sysfs /sys $MNT/sys
  chroot $MNT bash /_script
  chroot $MNT apt-get -y autoremove
  chroot $MNT apt-get clean
  umount -fR $MNT/proc; umount -fR $MNT/sys; umount -fR $MNT/dev
  rm -rf $MNT/_script
  DIR=$(pwd); cd $MNT && tar czf ../${1}.tar.gz . && cd $DIR
}

{
  echo -n '#BASE '
  date +%s
  ( set -o posix; set ) | grep LESSBIAN
  echo
} > $MNT/etc/lessbian-env

_build NOX << EOF
passwd -d root
apt-get update
apt-get -y install localepurge
apt-get -y install linux-image-amd64 grub2 firmware-linux initramfs-tools
tasksel install standard laptop
EOF

_build X << EOF
#apt-get -y install gnome-session-flashback
apt-get -y install gnome-session
apt-get -y --purge remove plymouth
apt-get --no-install-recommends -y install gnome-terminal sudo
adduser --disabled-password --gecos "" user
passwd -d user
adduser user sudo
echo 'root ALL=(ALL) NOPASSWD:ALL
user ALL=(ALL) NOPASSWD:ALL
' > /etc/sudoers.d/nopass
EOF

rm -rf $MNT

exit 0
