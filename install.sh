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
  {
    echo "---- $1"
    ( set -o posix; set ) | grep LESSBIAN
  } >&2
  exit
}
run_in_chroot(){
  local script="$LESSBIAN_MOUNT_TARGET/chroot_script.sh"
  {
    echo "#!/usr/bin/env bash"
    echo; echo "set -e"
    echo "echo Running '$1' in chroot && export DEBIAN_FRONTEND=noninteractive"
    echo "err_trap() { read -p '$1 Line \$1'; }"
    echo "trap 'err_trap \$LINENO' ERR"
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
  umount $LESSBIAN_MOUNT_TARGET/proc || sleep 10 && umount -lf $LESSBIAN_MOUNT_TARGET/proc || true
  umount $LESSBIAN_MOUNT_TARGET/dev || sleep 10 && umount -lf $LESSBIAN_MOUNT_TARGET/dev || true
  umount $LESSBIAN_MOUNT_TARGET/sys || sleep 10 && umount -lf $LESSBIAN_MOUNT_TARGET/sys || true
  rm -rf $script
}
build_base(){
  [ "x$1" == x ] && exit_script "Usage: build_base NOX|X [y]"
  [ "x$LESSBIAN_MOUNT_TARGET == x" ]\
    || [ -d $LESSBIAN_MOUNT_TARGET ]\
    || exit_script "Bad mount target '$LESSBIAN_MOUNT_TARGET'"

  ( debootstrap --help; wget --help; chroot --help ) > /dev/null
  # --variant=minbase
  debootstrap --arch=amd64 $LESSBIAN_DEBIAN_RELEASE $LESSBIAN_MOUNT_TARGET http://ftp.us.debian.org/debian/
  run_in_chroot "_step1" < <(get_file base/_step1.sh)
  get_file debian-releases/$LESSBIAN_DEBIAN_RELEASE-sources.list > $LESSBIAN_MOUNT_TARGET/etc/apt/sources.list
  run_in_chroot "_step2" < <(get_file base/_step2.sh)

  run_in_chroot "${LESSBIAN_DEBIAN_RELEASE}-NOX" < <(get_file base/NOX.sh)
  [ "x$2" == "xy" ] &&\
    { DIR=$(pwd); cd $LESSBIAN_MOUNT_TARGET && tar czf $DIR/NOX.tar.gz . && cd $DIR; }

  if [ "x$1" == xX ]; then
    run_in_chroot "${LESSBIAN_DEBIAN_RELEASE}-X" < <(get_file base/X.sh)
    [ "x$2" == "xy" ] &&\
      { DIR=$(pwd); cd $LESSBIAN_MOUNT_TARGET && tar czf $DIR/X.tar.gz . && cd $DIR; }
  fi

  [ "x$2" == "xy" ] && rm -rf $LESSBIAN_MOUNT_TARGET/*
  echo "Base built" >&2
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
  build_base X y
  exit_script
fi


(debootstrap --help; grub-install --help; wget --help; chroot --help) > /dev/null


if [ ! -f variant.sh ]; then
  if [ "x$LESSBIAN_VARIANT" == x ]; then
    IFS=$'\n' read -d '' -r -a variants < <(get_file variants/_list | cut -d'.' -f1 && printf '\0')
    for (( i=0; i<${#variants[@]}; i++ )); do
      printf "%2s  %s\n" "$i" "${variants[$i]}"
    done
    read -p "Choose variant [0]: " variant
    export LESSBIAN_VARIANT=${variants[${variant:-0}]}
  fi
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
  [ "x$dev" == x ] || [ ! -e "/dev/$dev" ] && exit_script "Bad install device '$LESSBIAN_INSTALL_DEV'"
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


mkdir -p $LESSBIAN_MOUNT_TARGET/var/log/lessbian
export LESSBIAN_LOG_FILE=$LESSBIAN_MOUNT_TARGET/var/log/lessbian/install.log
exec > >(tee $LESSBIAN_LOG_FILE) 2>&1


mkdir -p $LESSBIAN_MOUNT_TARGET
mount /dev/$LESSBIAN_INSTALL_DEV $LESSBIAN_MOUNT_TARGET


if [ "x$LESSBIAN_BASE_FRESH" == xy ]; then
  build_base $LESSBIAN_BASE
else
  base_file=base-${LESSBIAN_BASE}.tar.gz
  if [ ! -f $base_file ]; then
    read -p "Base file not found. Input anything to build a fresh base or nothing to download: " get_base
    if [ "x$get_base" == x ]; then
      wget $LESSBIAN_BASE_URL/$LESSBIAN_DEBIAN_RELEASE/$base_file 2> >(\
        grep ERROR && echo "$LESSBIAN_BASE_URL/$LESSBIAN_DEBIAN_RELEASE/$base_file" && exit_script \
      )
      cat $base_file | tar xzf - -C $LESSBIAN_MOUNT_TARGET
    else
      build_base $LESSBIAN_BASE
    fi
  fi
fi


for i in part-*.sh; do
  cat $i | run_in_chroot "$i"
done


echo "echo '$LESSBIAN_HOSTNAME' > /etc/hostname
apt-get -yqq install grub2
#grub-mkconfig -o /boot/grub/grub.cfg
update-grub" | run_in_chroot "_step3"


grub-install --root-directory=$LESSBIAN_MOUNT_TARGET /dev/${LESSBIAN_INSTALL_DEV%[0-9]}


{
  echo '---- variant.sh'
  cat variant.sh
  echo '---- env'
  ( set -o posix; set ) | grep LESSBIAN
} >> $LESSBIAN_LOG_FILE


umount $LESSBIAN_MOUNT_TARGET


exit_script
