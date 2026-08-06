echo $LESSBIAN_HOSTNAME > /etc/hostname
#echo 'nameserver 8.8.8.8' > /etc/resolv.conf
echo 127.0.1.1 $LESSBIAN_HOSTNAME >> /etc/hosts

#TRACKER_MINERS_DIR=/dev/null
# echo "TRACKER_MINERS_DIR=/dev/null" | \
#   tee /etc/environment.d/99-block-tracker.conf > /dev/null
systemctl --user --now mask localsearch-3.service localsearch-control-3.service localsearch-writeback-3.service
echo "X-GNOME-Autostart-enabled=false" >> /etc/xdg/autostart/localsearch-3.desktop
