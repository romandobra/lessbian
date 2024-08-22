export DEBIAN_FRONTEND=noninteractive
#apt-get -yq install gnome-session-flashback
apt-get -yq install gnome-session
apt-get -yq --purge remove plymouth
apt-get --no-install-recommends -yq install gnome-terminal sudo
adduser --disabled-password --gecos "" user
passwd -d user
adduser user sudo
echo 'root ALL=(ALL) NOPASSWD:ALL
user ALL=(ALL) NOPASSWD:ALL
' > /etc/sudoers.d/nopass
