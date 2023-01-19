# 1.5 some things meant for previously
info Determining timezone automatically
# timezone=$(tzselect)
timezone=$(curl -s "http://ip-api.com/csv/$(curl -s https://ipapi.co/ip)?fields=timezone")
info Timezone is: $timezone. Setting timezone and syncing clocks.
sudo timedatectl set-timezone "$timezone"
sudo timedatectl set-ntp true
sudo hwclock --systohc
timedatectl timesync-status


# 2. Set hostname
sudo hostnamectl set-hostname $HOSTNAME


