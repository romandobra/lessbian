wget -qO /home/user/dconf $LESSBIAN/parts/dconf
chown user /home/user/dconf
runuser -c 'cat /home/user/dconf | dconf load /' user
rm /home/user/dconf
