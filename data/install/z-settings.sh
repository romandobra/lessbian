echo $LESSBIAN_HOSTNAME > /etc/hostname
echo 'nameserver 8.8.8.8' > /etc/resolv.conf
echo 127.0.1.1 $LESSBIAN_HOSTNAME >> /etc/hosts
apt-get -y install grub2
