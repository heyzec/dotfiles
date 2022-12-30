info installing sudo
pacman -S sudo --noconfirm --needed


info creating new user
usermod -aG wheel $USERNAME


# Then fix /etc/sudoers

info Disabling root login
passwd -d -l root
