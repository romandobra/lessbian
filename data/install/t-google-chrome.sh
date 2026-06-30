chmod -x $(type -p gnome-keyring-daemon)

wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -

echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main'\
    | tee /etc/apt/sources.list.d/google-chrome.list

apt-get update
apt-get -y install google-chrome-stable

sleep 1
sed -i 's/google-chrome-stable %U/google-chrome-stable --no-first-run %U/' /usr/share/applications/google-chrome.desktop

# read

# 
# wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
# wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# dpkg -i google-chrome-stable_current_amd64.deb || true
# apt-get -y install -f

# dpkg -i google-chrome-stable_current_amd64.deb || true

# read

# rm -rf google-chrome-stable_current_amd64.deb
