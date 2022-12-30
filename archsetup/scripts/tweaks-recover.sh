sudo pacman -S xorg-xkill

# then, setup keyboard shortcut



# Enable all SysRq functions
echo 'kernel.sysrq=1' | sudo tee /etc/sysctl.d/99-reisub.conf 
