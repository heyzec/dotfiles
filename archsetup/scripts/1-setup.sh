# 1. Network setup
#
# Assume dhcp installed beforehand
# need dhcp here too
systemctl enable dhcpcd --now
systemctl enable systemd-resolved --now
systemctl enable iwd --now

iwctl station wlan0 get-networks
iwctl station wlan0 connect "Singtel-J249"

# Check for internet connection before proceeding
ping -c 1 8.8.8.8 || exit 1

# Sync pacakge databases
pacman -Syu
pacman -S --noconfirm archlinux-keyring #update keyrings to latest to prevent packages failing to install
pacman -S --noconfirm --needed reflector
# 1.2. Setup mirrors for opitmal download
iso=$(curl -4 ifconfig.co/country-iso)
echo -ne "
-------------------------------------------------------------------------
                    Setting up $iso mirrors for faster downloads
-------------------------------------------------------------------------
"
reflector -a 48 -c $iso -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist



# 1.5 some things meant for previously
# List of time zones
# To set the timezone automatically based on the IP address location, one can use a geolocation API to retrieve the timezone, for example curl https://ipapi.co/timezone, and pass the output to timedatectl set-timezone for automatic setting. Some geo-IP APIs that provide free or partly free services are listed below:
# timedatectl list-timezones
timedatectl set-timezone Asia/Singapore
# tzselect has a good selector, but does not edit files directly
hwclock --systohc
timedatectl status



# 2. Set hostname



# 3. User control
pacman -S sudo --noconfirm --needed


useradd -m -G wheel -s /bin/bash $USERNAME


# Then fix /etc/sudoers

# Disable root login
passwd -d -l root
# Add sudo no password rights
sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers

