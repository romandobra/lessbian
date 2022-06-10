# Debian Bullseye
#deb http://deb.debian.org/debian/ bullseye main contrib non-free

# bullseye-backports
echo 'deb http://deb.debian.org/debian bullseye-backports main contrib non-free' >> /etc/apt/sources.list

apt update
apt -y install -t bullseye-backports nvidia-driver firmware-misc-nonfree
