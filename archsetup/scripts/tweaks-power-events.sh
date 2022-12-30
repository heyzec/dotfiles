# Prevent accidental shutoff
sudo sed -i 's/#HandlePowerKey=poweroff/HandlePowerKey=suspend/' /etc/systemd/logind.conf
sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
