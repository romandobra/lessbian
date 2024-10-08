#!/usr/bin/env bash

set -e

exec > >(tee lessbian-fresh-install.log) 2>&1

export DEBCONF_FRONTEND=noninteractive
apt-get -y update
apt-get -y install debootstrap grub2

fdisk /dev/sda <<EOF
n
p



w
q
EOF

mkfs.ext4 /dev/sda1

sleep 1
export LESSBIAN_DEBIAN_RELEASE=bookworm
export LESSBIAN_VARIANT=x-1
#export LESSBIAN_JUST_BASE=y
export LESSBIAN_SKIP_REVIEW=y
export LESSBIAN_INSTALL_DEV=sda1
export LESSBIAN_MOUNT_TARGET=/mnt
export LESSBIAN_HOSTNAME=lessbian-tester
export LESSBIAN_BASE_FRESH=y

wget https://raw.githubusercontent.com/romandobra/lessbian/main/install.sh

sleep 1
bash install.sh

sleep 1
mount /dev/sda1 /mnt
mv lessbian-fresh-install.log /mnt/var/log/
umount /mnt
