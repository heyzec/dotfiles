
# Display Manager: Starts the X-server
sudo pacman -S xorg-server # Lightdm depends on xorg-server as well
sudo pacman -S lightdm lightdm-gtk-greeter  # Greeter required, can configure
sudo pacman -S xorg-xinit --noconfirm --needed

# WM
sudo pacman -S i3-gaps --noconfirm --needed
# Create xinitrc file for Xorg to start i3 as well

# Then, copy in dotfiles for i3


# Some useful apps
# vim, my fotfiles 


# Terminal
sudo pacman -S tilix --noconfirm --needed
# Then, fix VTE issue in bashrc/zshrc

