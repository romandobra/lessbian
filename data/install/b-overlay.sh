wget -O -\
  https://raw.githubusercontent.com/romandobra/stateless-debian/main/install.sh\
  | bash

echo 'OVERLAY_MODE=toram' > /etc/overlay
