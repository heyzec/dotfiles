cat > /etc/NetworkManager/conf.d/iwd.conf << END
[device]
wifi.backend=iwd
END

sudo systemctl stop NetworkManager
sudo systemctl disable --now wpa_supplicant
sudo systemctl restart NetworkManager

pacman -S network-manager
pacman -S network-manager-applet
