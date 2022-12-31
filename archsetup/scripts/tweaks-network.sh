sudo tee /etc/NetworkManager/conf.d/iwd.conf << END > /dev/null
[device]
wifi.backend=iwd
END

sudo systemctl stop NetworkManager
sudo systemctl disable --now wpa_supplicant
sudo systemctl restart NetworkManager

sudo pacman -S network-manager
sudo pacman -S network-manager-applet
