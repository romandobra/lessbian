echo 'nameserver 8.8.8.8' > /etc/resolv.conf

apt-get --no-install-recommends -y install \
	debootstrap \
	eject \
	dosfstools \
	rsync \
	sshfs
