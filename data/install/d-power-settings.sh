echo '[Login]
HandlePowerKey=poweroff
HandleSuspendKey=poweroff
HandleHibernateKey=poweroff
HandleLidSwitch=poweroff
HandleLidSwitchExternalPower=poweroff
HandleLidSwitchDocked=poweroff
PowerKeyIgnoreInhibited=yes
SuspendKeyIgnoreInhibited=yes
HibernateKeyIgnoreInhibited=yes
LidSwitchIgnoreInhibited=yes
IdleAction=ignore' > /etc/systemd/logind.conf

systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
