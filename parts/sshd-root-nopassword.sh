echo 'OVERLAY_MODE=toram' > /etc/overlay

echo '[Match]
Name=enp*

[Network]
DHCP=ipv4' > /etc/systemd/network/20-dhcp.network
systemctl enable systemd-networkd

apt-get -y install openssh-server

passwd -d root
echo 'PermitEmptyPasswords yes
PermitRootLogin yes' > /etc/ssh/sshd_config.d/nopass.conf
