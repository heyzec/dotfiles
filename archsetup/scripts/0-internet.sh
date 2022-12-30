# 1. Network setup
section 1-setup
#
# Assume dhcp installed beforehand
# need dhcp here too
systemctl enable dhcpcd --now
systemctl enable systemd-resolved --now
systemctl enable iwd --now

iwctl station wlan0 get-networks
iwctl station wlan0 connect "Singtel-J249"

info Checking for internet connection before proceeding
ping -c 1 8.8.8.8 || exit 1
