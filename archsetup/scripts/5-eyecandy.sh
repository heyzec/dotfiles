
# Tooling
sudo pacman -S base-devel --needed # TOols for building: compiling and linking







# Install AUR helper
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
zsh
chsh -s /bin/zsh heyzec
# Link dotfiles

# Useful app: firefox
sudo pacman -S firefox --noconfirm --needed


# 5. Complete graphical environment
# Xorg Desktop compositor
sudo pacman -S picom --noconfirm --needed
# Notification daemon
sudo pacman -S libnotify dunst --noconfirm --needed
# Display manager
# Screen locker
# need i3lock-color from AUR
# Application launcher
sudo pacman -S rofi --noconfirm --needed
# Audio control
# Backlight control
sudo pacman -S light --noconfirm --needed
sudo usermod -aG video heyzec
# Media Control
sudo pacman -S playerctl --noconfirm --needed
# Polkit agent
# Screen capture
sudo pacman -S flameshot --noconfirm --needed
# Screen temperature
# Wallpaper setter
sudo pacman -S xbackground --noconfirm --needed
# Logout dialog
# Taskbar
sudo pacman -S polybar --noconfirm --needed

sudo yay -S i3lock-color --noconfirm --needed




# Fonts
git clone https://github.com/tallesairan/FA5PRO
mkdir -p /usr/local/share/fonts
cp -r FA5PRO/otfs /usr/local/share/fonts/otf
fc-cache
