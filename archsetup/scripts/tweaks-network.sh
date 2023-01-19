# iwd is still not a full replacement for wpa_supplicant because it can't provide GUI connection to 802.1x networks
sudo tee /etc/NetworkManager/conf.d/iwd.conf << END > /dev/null
[device]
wifi.backend=iwd
END

# If using NetworkManager, ensure wpa_supplicant is disabled as NM will call wpa_supplicant instead

sudo systemctl stop NetworkManager
sudo systemctl disable --now wpa_supplicant
sudo systemctl restart NetworkManager

sudo pacman -S network-manager
sudo pacman -S network-manager-applet
