#!/usr/bin/env bash

passwd -d root

apt-get -y install localepurge tasksel
apt-get -y install linux-image-amd64 firmware-linux

tasksel install standard laptop
