wget -qO /etc/systemd/logind.conf $LESSBIAN_GITHUB_URL/parts/logind
systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
