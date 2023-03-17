cd "$(dirname "$0")"

if ! fc-match 'heyzec\-polybar\-icon\-fonts:style=Regular' | grep 'heyzec-polybar-icon-fonts'; then
    mkdir ~/.local/share/fonts
    cp polybar/heyzec-polybar-icons.ttf ~/.local/share/fonts/
fi



# Note to fix: if ~/.config/i3 folder exists, the symlink is created in that folder. this breaks paths
ln -s -T -fi $(realpath sway/) ~/.config/sway
ln -s -T -fi $(realpath waybar/) ~/.config/waybar
ln -s -T -fi $(realpath picom/) ~/.config/picom
ln -s -T -fi $(realpath rofi/) ~/.config/rofi
