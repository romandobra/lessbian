
#Version 470.103.01
#echo 'deb http://deb.debian.org/debian bullseye-backports main contrib non-free' >> /etc/apt/sources.list
#apt update
#apt -y install -t bullseye-backports nvidia-driver firmware-misc-nonfree


#Version 460.91.03
apt update
apt -y install nvidia-driver firmware-misc-nonfree libnvidia-encode1
