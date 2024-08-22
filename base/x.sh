#apt-get -yq install gnome-session-flashback
apt-get -yqq install gnome-session
apt-get -yqq --purge remove plymouth
apt-get --no-install-recommends -yqq install gnome-terminal sudo
adduser --disabled-password --gecos "" user
passwd -d user
adduser user sudo
echo 'root ALL=(ALL) NOPASSWD:ALL
user ALL=(ALL) NOPASSWD:ALL
' > /etc/sudoers.d/nopass
