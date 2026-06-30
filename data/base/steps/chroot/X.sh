#!/usr/bin/env bash

#apt-get -yq install gnome-session-flashback

apt-get -y install gnome-session
apt-get -y --purge remove plymouth yelp
apt-get --no-install-recommends -y install gnome-terminal sudo
adduser --disabled-password --gecos "" user
passwd -d user
adduser user sudo
echo "root ALL=(ALL) NOPASSWD:ALL
user ALL=(ALL) NOPASSWD:ALL
" > /etc/sudoers.d/nopass
