#!/usr/bin/env bash

#apt-get -yqq install software-properties-common
apt-get -y install ca-certificates

apt-get -y install locales
sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
dpkg-reconfigure --frontend=noninteractive locales
