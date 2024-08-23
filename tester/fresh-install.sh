fdisk /dev/sda <<EOF
n
p



w
q
EOF

mkfs.ext4 /dev/sda1

export DEBCONF_FRONTEND=noninteractive
apt-get -yqq update
apt-get -yqq install debootrstrap grub2

sleep 1
export LESSBIAN_DEBIAN_RELEASE=buster
export LESSBIAN_VARIANT=x-0
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
reboot
