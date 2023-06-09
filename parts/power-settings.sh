wget -qO /etc/systemd/logind.conf $LESSBIAN/parts/logind
systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
