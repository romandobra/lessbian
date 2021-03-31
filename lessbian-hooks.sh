mkdir -p /home/${LIVE_USERNAME}/.config/autostart
echo '[Desktop Entry]
Type=Application
Exec=lessbian-autostart
Hidden=false
X-GNOME-Autostart-enabled=true
Name=lessbian-autostart' > /home/${LIVE_USERNAME}/.config/autostart/lessbian-autostart.desktop
echo '. go' > /home/${LIVE_USERNAME}/.bash_history
chown -R ${LIVE_USERNAME} /home/${LIVE_USERNAME}

echo "gsettings set org.gnome.desktop.background picture-options none
gnome-terminal --tab -e \"echo HELLO\"
" > /usr/bin/lessbian-autostart
chmod +x /usr/bin/lessbian-autostart
