chmod -x $(type -p gnome-keyring-daemon)
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb || true
apt-get --no-install-recommends -y install -f

dpkg -i google-chrome-stable_current_amd64.deb || true

read

rm -rf google-chrome-stable_current_amd64.deb

# TODO maybe sleep 1 here?
# no such file
# sed -i 's/google-chrome-stable %U/google-chrome-stable --no-first-run %U/' /usr/share/applications/google-chrome.desktop
