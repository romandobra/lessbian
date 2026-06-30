#!/usr/bin/env bash

set -e


exit_script(){
  echo_script "! $1"
  echo_script "-"
  echo_script "$(( set -o posix; set ) | grep LESSBIAN)"
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
  touch $LESSBIAN_MNT/etc/resolv.conf
  mount -o bind /etc/resolv.conf $LESSBIAN_MNT/etc/resolv.conf
  sleep 1; }


lb_umount(){
  echo_script "Unmounting dev, proc, sys"
  umount $LESSBIAN_MNT/proc
  umount $LESSBIAN_MNT/sys
  umount $LESSBIAN_MNT/dev
  umount $LESSBIAN_MNT/etc/resolv.conf
  rm -rf $LESSBIAN_MNT/etc/resolv.conf
  sleep 1; }


run_in_chroot(){
  echo_script "Run in chroot: $1"

  [ -z "$( ls -A $LESSBIAN_MNT )" ]\
    && exit_script "Target is empty" 4

  local script="$LESSBIAN_MNT/chroot_script.sh"
  {
    echo "#!/usr/bin/env bash"
    echo
    echo "apt-get -y update"
    echo "set -e"
    echo "export DEBIAN_FRONTEND=noninteractive"
    cat $1
    echo
    echo "apt-get -y update --fix-missing"
    echo "apt-get -y autoremove && apt-get -y clean"
  } > $script
  chmod +x $script

  lb_mount

  chroot $LESSBIAN_MNT /chroot_script.sh\
    || { lb_umount && exit_script "Error" 5; }

  lb_umount
  
  rm -rf $script; }


choose_parts(){
  echo hi2
  options=()
  while IFS= read -r file; do
    tag=${file%%\-*}

    [ ${tag:0:1} == _ -o $tag == z ] && continue

    name=${file#*\-}
    name=${name%.*}

    on_off=off

    [ $tag == b -o $tag == d -o $tag == h ] && on_off=on

    options+=("$tag" "$name" "$on_off")
  done < <(ls -1 data/install)

  exec 3>&1
  chosen=$(dialog --title "Lessbian parts" \
    --checklist "Choose parts:" 0 0 0 \
    "${options[@]}" \
    2>&1 1>&3)
  exec 3>&-

  exit_status=$?

  if [ $exit_status -ne 0 ]; then
    exit_script "Cancelled." $exit_status; fi

  parts="${chosen// /}z"; }


export -f exit_script echo_script lb_mount lb_umount\
  run_in_chroot choose_parts


[[ $EUID -ne 0 ]] && exit_script "sudo -i" 1


[ "x$LESSBIAN_MNT" == x ]\
  && exit_script "LESSBIAN_MNT=" 1

[ -d $LESSBIAN_MNT ]\
  || exit_script "'$LESSBIAN_MNT' is not a directory" 2


if [ "x$LESSBIAN_DR" == x ]; then
  IFS=$'\n' read -d '' -r -a releases < <(cat data/debian-releases.txt && printf '\0')
    for (( i=0; i<${#releases[@]}; i++ )); do
    printf "%2s  %s\n" "$i" "${releases[$i]}"
  done
  read -p "Debian release [$((${#releases[@]}-1))]: " release
  export LESSBIAN_DR=${releases[${release:-$((${#releases[@]}-1))}]}
fi
