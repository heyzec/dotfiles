section 4-windowed window manager
sudo pacman -S i3-gaps --noconfirm --needed
info Starting i3 window manager
# Bash on tty2 should start i3 now

# Make i3 not complain about no config
# mkdir -p /home/$USERNAME/.config/i3
# touch /home/$USERNAME/.config/i3/config



section 4-windowed terminal
info installing tilix
sudo pacman -S tilix --noconfirm --needed
# Then, fix VTE issue in bashrc/zshrc
#
pkill xterm
DISPLAY=:0 tilix -e tmux at -t sess &

