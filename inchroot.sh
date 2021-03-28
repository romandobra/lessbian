#!/bin/bash

#echo 'LANG="en_US"
#LANGUAGE="en_US:en"' > /etc/default/locale
#locale-gen

apt-get update

apt-get -y install gnome-session
apt-get -y install gnome-disk-utility

apt-get -y --purge autoremove
#apt-get -y clean

exit
