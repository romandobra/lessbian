#!/usr/bin/env bash

set -e
(grub-install --help; wget --help; chroot --help) > /dev/null

export LESSBIAN_GIT='https://raw.githubusercontent.com/romandobra/lessbian/main'

if [ ! -f settings.sh ]; then
  echo
  echo 'File settings.sh not found.'
  echo 'Download it from (leave empty to exit):'
  read -p "$LESSBIAN_GIT/settings/***.sh: "
  if [[ "x$REPLY" == "x" ]]; then exit 1; fi
  wget -O settings.sh $LESSBIAN_GIT/settings/${REPLY}.sh || exit 2
fi
source settings.sh
LESSBIAN_BASE=$BASE
LESSBIAN_PARTS=$PARTS

COUNTER=0
for i in $LESSBIAN_PARTS; do
  let "COUNTER+=5"
  wget -O custom-$(printf "%02d\n" $COUNTER)-${i}.sh $LESSBIAN_GIT/parts/${i}.sh
done || true

echo "settings.sh and custom-***.sh files are downloaded."
read -p "Review them if needed and press Enter to install"

ls -la /dev/disk/by-id; read -p "DEV=/dev/" DEV; DEV="/dev/$DEV"
read -p "Mount to [/mnt]: " MNT; MNT=${MNT:-/mnt}

if [ ! -f ${LESSBIAN_BASE}.tar.gz ]; then wget https://github.com/romandobra/lessbian/releases/download/v2.0/${LESSBIAN_BASE}.tar.gz; fi

mkdir -p $MNT; mount $DEV $MNT
cat ${LESSBIAN_BASE}.tar.gz | tar xzf - -C $MNT

mkdir $MNT/_host; mount -B / $MNT/_host
mount -t proc /proc $MNT/proc; mount -t sysfs /sys $MNT/sys; mount -B /dev $MNT/dev

{
  echo -n '#INSTALL '
  date +%s
  ( set -o posix; set ) | grep LESSBIAN
  echo
} > $MNT/etc/lessbian-env

for i in custom*; do
  cp $i $MNT/s
  chroot $MNT bash /s
  rm $MNT/s
done || true

chroot $MNT apt-get -y install grub2
chroot $MNT apt-get -y autoremove
chroot $MNT apt-get clean
#chroot $MNT grub-mkconfig -o /boot/grub/grub.cfg
chroot $MNT update-grub

umount -fR $MNT/proc; umount -fR $MNT/sys; umount -flR $MNT/dev
umount -fR $MNT/_host; rmdir $MNT/_host

grub-install --root-directory=$MNT "${DEV%[0-9]}"
umount -fR $MNT
