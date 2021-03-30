mkdir -p /home/${LIVE_USERNAME}/.config/autostart
echo '[Desktop Entry]
Type=Application
Exec=lessbian-autostart
Hidden=false
X-GNOME-Autostart-enabled=true
Terminal=true
Name=lessbian-autostart' > /home/${LIVE_USERNAME}/.config/autostart/lessbian-autostart.desktop

chown -R ${LIVE_USERNAME} /home/${LIVE_USERNAME}
