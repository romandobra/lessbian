chmod -x $(type -p gnome-keyring-daemon)


# 1. Create the secure keyrings directory with correct permissions
mkdir -m 755 -p /etc/apt/keyrings

# 2. Download Google's GPG key, de-armor it, and save it securely
wget -qO- https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor | tee /etc/apt/keyrings/google-chrome.gpg > /dev/null

# 3. Add the Chrome repository pointing directly to that specific key
echo 'deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main' \
    | tee /etc/apt/sources.list.d/google-chrome.list

# 4. Update your package list and install Google Chrome
apt-get update
apt-get -y install google-chrome-stable


# wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -

# echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main'\
#     | tee /etc/apt/sources.list.d/google-chrome.list

# apt-get update
# apt-get -y install google-chrome-stable

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
