mkdir -p /etc/systemd/system/getty@tty1.service.d

echo '[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin root --noclear %I 38400 linux'\
  > /etc/systemd/system/getty@tty1.service.d/override.conf

systemctl enable getty@tty1.service
