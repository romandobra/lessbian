echo '[Match]
Name=enp*

[Network]
DHCP=ipv4' > /etc/systemd/network/20-dhcp.network
systemctl enable systemd-networkd

systemctl enable ssh

echo 'PermitEmptyPasswords yes
PermitRootLogin yes' > /etc/ssh/sshd_config.d/nopass.conf
