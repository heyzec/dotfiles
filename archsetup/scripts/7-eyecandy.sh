
# Tooling
info "Tools for building (compiling and linking)"
sudo pacman -S base-devel --noconfirm --needed





# needed for now, can remove once all scripts enabled
sudo pacman -S git --noconfirm

# Install AUR helper
git clone https://aur.archlinux.org/yay.git
(cd yay && makepkg -si --noconfirm --needed)
sudo pacman -S zsh --noconfirm --needed
sudo chsh -s /bin/zsh $USERNAME
