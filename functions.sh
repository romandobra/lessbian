#!/usr/bin/env bash

set -e


exit_script(){
  {
    echo -e "\033[0;36m$1"
    ( set -o posix; set ) | grep LESSBIAN
    echo -e -n "\033[0m"
  } >&2
  exit $2; }


echo_script(){
  {
    echo -e "\033[0;36m$1"
    echo -e -n "\033[0m"
  } >&2; }


lb_mount(){
  echo_script "Mounting dev, proc, sys"
  mount -t proc none $LESSBIAN_MNT/proc
  mount -o bind /dev $LESSBIAN_MNT/dev
  mount -o bind /sys $LESSBIAN_MNT/sys
  sleep 1; }


lb_umount(){
  echo_script "Unmounting dev, proc, sys"
  umount $LESSBIAN_MNT/proc
  umount $LESSBIAN_MNT/sys
  umount $LESSBIAN_MNT/dev
  sleep 1; }


run_in_chroot(){
  echo_script "Run in chroot: $1"

  [ -z "$( ls -A $LESSBIAN_MNT )" ]\
    && exit_script "Target is empty" 4

  local script="$LESSBIAN_MNT/chroot_script.sh"
  {
    echo "#!/usr/bin/env bash"
    echo
    echo "apt-get -yqq update"
    echo "set -e"
    echo "export DEBIAN_FRONTEND=noninteractive"
    cat $1
    echo
    echo "apt-get -yqq autoremove && apt-get -yqq clean"
  } > $script
  chmod +x $script

  lb_mount

  chroot $LESSBIAN_MNT /chroot_script.sh\
    || { lb_umount && exit_script "Error" 5; }

  lb_umount
  
  rm -rf $script; }


export -f exit_script echo_script\
  lb_mount lb_umount run_in_chroot 


[[ $EUID -ne 0 ]] && exit_script "Must be root" 1


[ "x$LESSBIAN_MNT" == x ]\
  && exit_script "Target is not set" 1

[ -d $LESSBIAN_MNT ]\
  || exit_script "Target is not a directory" 2


if [ "x$LESSBIAN_DR" == x ]; then
  IFS=$'\n' read -d '' -r -a releases < <(cat data/debian-releases.txt && printf '\0')
    for (( i=0; i<${#releases[@]}; i++ )); do
    printf "%2s  %s\n" "$i" "${releases[$i]}"
  done
  read -p "Debian release [0]: " release
  export LESSBIAN_DR=${releases[${release:-0}]}
fi
