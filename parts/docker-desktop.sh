#!/usr/bin/env bash

sudo apt-get update
sudo apt-get -y install \
    ca-certificates \
    curl \
    gnupg

sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

curl -sS --output docker.deb https://desktop.docker.com/linux/main/amd64/docker-desktop-4.18.0-amd64.deb

sudo apt-get update
sudo apt-get -y install ./docker.deb

sudo rm docker.deb
