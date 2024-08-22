#!/usr/bin/env bash

set -e
if [ "$1" == clean ]; then rm -rf {part-*.sh,variant.sh}; fi


[ "x$LESSBIAN_GITHUB_URL" == x ] &&\
  export LESSBIAN_GITHUB_URL='https://raw.githubusercontent.com/romandobra/lessbian/main'

[ "x$LESSBIAN_BASE_URL" == x ] &&\
  export LESSBIAN_BASE_URL='https://github.com/romandobra/lessbian/releases/download'


get_file(){
  if [ -f $1 ]; then
    cat $1
  else
    wget -O - "$LESSBIAN_GITHUB_URL/$1" 2> >(grep ERROR >&2 && echo "$LESSBIAN_GITHUB_URL/$1" >&2 && exit_script)
  fi
}
exit_script(){
  echo '----'
  # env | grep -E '^LESSBIAN_'
  ( set -o posix; set ) | grep LESSBIAN
  exit
}
run_in_chroot(){
  local script="$LESSBIAN_MOUNT_TARGET/chroot_script.sh"
  {
    echo "echo Running $1 in chroot && export DEBIAN_FRONTEND=noninteractive"
    cat -
    echo 'apt-get -yqq autoremove && apt-get -yqq clean'
  } > $script
  chmod +x $script
  echo Mounting dev, proc, sys
  mount -t proc none $LESSBIAN_MOUNT_TARGET/proc
  mount -o bind /dev $LESSBIAN_MOUNT_TARGET/dev
  mount -o bind /sys $LESSBIAN_MOUNT_TARGET/sys
  chroot $LESSBIAN_MOUNT_TARGET /chroot_script.sh
  echo Unmounting dev, proc, sys
  umount $LESSBIAN_MOUNT_TARGET/proc
  umount $LESSBIAN_MOUNT_TARGET/dev
  umount $LESSBIAN_MOUNT_TARGET/sys
  rm -rf $script
}
build_base(){
  ( debootstrap --help; wget --help; chroot --help ) > /dev/null
  # --variant=minbase
  debootstrap --arch=amd64 $LESSBIAN_DEBIAN_RELEASE $LESSBIAN_MOUNT_TARGET http://ftp.us.debian.org/debian/

  echo "apt-get -y install ca-certificates" | run_in_chroot "Prepare step 1"

  get_file debian-releases/$LESSBIAN_DEBIAN_RELEASE-sources.list > $LESSBIAN_MOUNT_TARGET/etc/apt/sources.list

  echo "\
apt-get -yqq update
apt-get -yqq install locales
sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
dpkg-reconfigure --frontend=noninteractive locales
" | run_in_chroot "Prepare step 2"

  run_in_chroot "${LESSBIAN_DEBIAN_RELEASE}-NOX" < <(get_file base/nox.sh)
  [ "x$1" == "xy" ] &&\
    { DIR=$(pwd); cd $LESSBIAN_MOUNT_TARGET && tar czf $DIR/NOX.tar.gz . && cd $DIR; }

  run_in_chroot "${LESSBIAN_DEBIAN_RELEASE}-X" < <(get_file base/x.sh)
  [ "x$1" == "xy" ] &&\
    { DIR=$(pwd); cd $LESSBIAN_MOUNT_TARGET && tar czf $DIR/X.tar.gz . && cd $DIR; }
}
export -f get_file exit_script build_base run_in_chroot


if [ "x$LESSBIAN_DEBIAN_RELEASE" == x ]; then
  IFS=$'\n' read -d '' -r -a releases < <(get_file debian-releases/_list && printf '\0')
    for (( i=0; i<${#releases[@]}; i++ )); do
    printf "%2s  %s\n" "$i" "${releases[$i]}"
  done
  read -p "Debian release [0]: " release
  export LESSBIAN_DEBIAN_RELEASE=${releases[${release:-0}]}
fi


if [ ! "x$LESSBIAN_JUST_BASE" == x ]; then
  [ "x$LESSBIAN_MOUNT_TARGET == x" ] && export LESSBIAN_MOUNT_TARGET=/mnt
  mkdir -p $LESSBIAN_MOUNT_TARGET
  build_base y
  exit_script
fi


if [ ! -f variant.sh ]; then
  IFS=$'\n' read -d '' -r -a variants < <(get_file variants/_list | cut -d'.' -f1 && printf '\0')
  for (( i=0; i<${#variants[@]}; i++ )); do
    printf "%2s  %s\n" "$i" "${variants[$i]}"
  done
  read -p "Choose variant [0]: " variant
  export LESSBIAN_VARIANT=${variants[${variant:-0}]}
  echo "export LESSBIAN_DEBIAN_RELEASE=$LESSBIAN_DEBIAN_RELEASE" >> variant.sh
  echo "export LESSBIAN_VARIANT=${variants[${variant:-0}]}" >> variant.sh
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
  fi
done


if [ "x$LESSBIAN_SKIP_REVIEW" == x ]; then
  read -p "Review part-* files if needed and press Enter to continue: "
fi


if [ "x$LESSBIAN_INSTALL_DEV" == x ]; then
  lsblk | grep part
  read -p "Device to install to (You have to set the boot flag manually): /dev/" dev
  [ "x$dev" == x ] || [ ! -e "/dev/$dev" ] && exit 1
  export LESSBIAN_INSTALL_DEV="/dev/$dev"
fi


if [ "x$LESSBIAN_MOUNT_TARGET" == x ]; then
  read -p "Mount target [/mnt]: " LESSBIAN_MOUNT_TARGET
  export LESSBIAN_MOUNT_TARGET=${LESSBIAN_MOUNT_TARGET:-/mnt}
fi


if [ "x$LESSBIAN_HOSTNAME" == x ]; then
  current_hostname=$(hostname)
  read -p "Host name [$current_hostname]: " LESSBIAN_HOSTNAME
  export LESSBIAN_HOSTNAME=${LESSBIAN_HOSTNAME:-$current_hostname}
fi


base_file=base-${LESSBIAN_BASE}.tar.gz
if [ ! -f base-$base_file ]; then
  read -p "Base file not found. Input anything to build a fresh base or nothing to download: " get_base
  if [ "x$get_base" == x ]; then
    wget $LESSBIAN_BASE_URL/$LESSBIAN_DEBIAN_RELEASE/$base_file 2> >(\
      grep ERROR && echo "$LESSBIAN_BASE_URL/$LESSBIAN_DEBIAN_RELEASE/$base_file" && exit_script \
    )
  else
    build_base
  fi
fi


exit_script



(grub-install --help; wget --help; chroot --help) > /dev/null

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
