key_path=/usr/share/keyrings/oracle-virtualbox-2016.gpg

wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc\
  | sudo gpg --dearmor --yes --output $key_path

echo -n "deb [arch=amd64 signed-by=$key_path]"\
  >> /etc/apt/sources.list
echo " https://download.virtualbox.org/virtualbox/debian $LESSBIAN_DEBIAN_RELEASE contrib"\
  >> /etc/apt/sources.list

apt-get -y update
apt-get -y install virtualbox-7.0
