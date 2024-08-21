#!/usr/bin/env bash

set -e
if [ "$1" == clean ]; then rm -rf {part-*.sh,variant.sh}; fi
(grub-install --help; wget --help; chroot --help) > /dev/null


export LESSBIAN_GIT='https://raw.githubusercontent.com/romandobra/lessbian/main'
get_file(){
    wget -q -O - "$LESSBIAN_GIT/$1"
}
export -f get_file


if [ ! -f variant.sh ]; then
  IFS=$'\n' read -d '' -r -a variants < <(get_file variants/_list | cut -d'.' -f1 && printf '\0')
  for (( i=0; i<${#variants[@]}; i++ )); do
    printf "%2s  %s\n" "$i" "${variants[$i]}"
  done
  read -p "Choose variant [0]: " variant
  export LESSBIAN_VARIANT=${variants[${variant:-0}]}
  echo "export LESSBIAN_VARIANT=${variants[${variant:-0}]}" > variant.sh
  get_file "variants/${LESSBIAN_VARIANT}.sh" >> variant.sh
fi
source variant.sh


export LESSBIAN_BASE=$BASE
export LESSBIAN_VARIANT_PARTS=$PARTS
IFS=' ' read -d '' -r -a LESSBIAN_PARTS < <(echo -n $LESSBIAN_VARIANT_PARTS && printf '\0')
for (( i=0; i<${#LESSBIAN_PARTS[@]}; i++ )); do
  file_name="part-$(printf '%02d' ${i})0-${LESSBIAN_PARTS[$i]}.sh"
  if [ ! -f "$file_name" ]; then
    get_file "parts/${LESSBIAN_PARTS[$i]}.sh" > "$file_name"
    else no_review="y"
  fi
done


if [ "x$no_review" == x ]; then
  read -p "Review part-* files if needed and press Enter to continue: "
fi


if [ "x$LESSBIAN_INSTALL_DEV" == x ]; then
  lsblk | grep part
  read -p "Device to install to (You have to set the boot flag manually): /dev/" LESSBIAN_INSTALL_DEV
  export LESSBIAN_INSTALL_DEV="/dev/$LESSBIAN_INSTALL_DEV"
fi


if [ "x$LESSBIAN_MOUNT_TARGET" == x ]; then
  read -p "Mount target [/mnt]: " LESSBIAN_MOUNT_TARGET
  export LESSBIAN_MOUNT_TARGET=${LESSBIAN_MOUNT_TARGET:-/mnt}
fi


env | grep -E '^LESSBIAN_'
exit




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

for i in part*; do
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
