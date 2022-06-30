echo 'nameserver 8.8.8.8' > /etc/resolv.conf

apt-get -y update
apt-get -y install --fix-missing

apt-get --no-install-recommends -y install \
	debootstrap \
	eject \
	dosfstools \
	rsync \
	sshfs
