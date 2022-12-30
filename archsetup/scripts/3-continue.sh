# 1.5 some things meant for previously
# List of time zones
# To set the timezone automatically based on the IP address location, one can use a geolocation API to retrieve the timezone, for example curl https://ipapi.co/timezone, and pass the output to timedatectl set-timezone for automatic setting. Some geo-IP APIs that provide free or partly free services are listed below:
# timedatectl list-timezones
info Setting timezone
timedatectl set-timezone Asia/Singapore
# tzselect has a good selector, but does not edit files directly
hwclock --systohc
timedatectl status



# 2. Set hostname
hostnamectl set-hostname $HOSTNAME



# 3. User control
#
#

info installing tmux
pacman -S tmux
