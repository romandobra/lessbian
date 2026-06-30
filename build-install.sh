#!/usr/bin/env bash

set -e

source functions.sh

( chroot --help; grub-install --help; dialog --help; ) > /dev/null

[ "x$LESSBIAN_DEV" == x ]\
  && exit_script "LESSBIAN_DEV=\n$(lsblk -n -l -o NAME,SIZE,MOUNTPOINT | grep -v "pool\|loop")" 4

[ -z "$( mount | grep $LESSBIAN_DEV | grep $LESSBIAN_MNT )" ]\
  && exit_script "mount /dev/$LESSBIAN_DEV $LESSBIAN_MNT"

[ -z "$( ls -A $LESSBIAN_MNT | grep -v 'lost+found' )" ]\
  && exit_script \
  "extract
  cat _base/$LESSBIAN_DR/NOX.tar.gz | tar -xf - -C $LESSBIAN_MNT
  cat _base/$LESSBIAN_DR/X.tar.gz | tar -xf - -C $LESSBIAN_MNT" 3

[ "x$LESSBIAN_HOSTNAME" == x ] && export LESSBIAN_HOSTNAME=$(hostname)

if [ -z "$1" ]; then choose_parts; else parts=$1; fi
clear

mkdir -p _install

{
  echo "export LESSBIAN_HOSTNAME=$LESSBIAN_HOSTNAME"

  for ((i=0; i<${#parts}; i++)); do
    char="${parts:i:1}"
    script=$(ls data/install | grep "^$char")
    echo
    echo "#######################"
    echo "# $script"
    echo
    cat "data/install/$script"
  done
} > _install/chroot_prepare.sh


{
  echo "update-grub"
} > _install/chroot_finish.sh

{
  echo '#!/usr/bin/env bash'
  echo
  echo $(( set -o posix; set ) | grep LESSBIAN )
  echo "source functions.sh"
  echo "run_in_chroot _install/chroot_prepare.sh"
  echo "grub-install --root-directory=$LESSBIAN_MNT /dev/${LESSBIAN_DEV%[0-9]}"
  echo "run_in_chroot _install/chroot_finish.sh"
  echo "echo_script 'umount $LESSBIAN_MNT && rm -rf _install && rm -rf _base'"
} > _install/run.sh

echo_script 'bash _install/run.sh'
