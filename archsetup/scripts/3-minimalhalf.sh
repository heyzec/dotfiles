
# Sound
sudo pacman -S alsa-utils --noconfirm --needed
sudo pacman -S sof-firmware  # needed for newer laptop models
sudo pacman -S wireplumber # provider for pipewire-session-manager
sudo pacman -S pipewire-jack # provider for jack



# Bluetooth
sudo pacman -S bluez  # Bluetooth protocol stack
sudo pacman -S bluez-utils  # For bluetoothctl
sudo systemctl enable bluetooth --now

