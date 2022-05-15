chmod -x $(type -p gnome-keyring-daemon)
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb || true
apt-get --no-install-recommends -y install -f
rm -rf google-chrome-stable_current_amd64.deb

sed -i 's/google-chrome-stable %U/google-chrome-stable --no-first-run %U/' /usr/share/applications/google-chrome.desktop
