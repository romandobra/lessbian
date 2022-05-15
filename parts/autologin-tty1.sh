mkdir -p /etc/systemd/system/getty@tty1.service.d
wget -O /etc/systemd/system/getty@tty1.service.d/override.conf $LESSBIAN/parts/tty-service
systemctl enable getty@tty1.service
