

section 3-minimalhalf: Setup sound
info installing alsa-utils
sudo pacman -S alsa-utils --noconfirm --needed
info installing sof-wirmware
sudo pacman -S sof-firmware --noconfirm --needed # needed for newer laptop models
info installing wireplumber
sudo pacman -S wireplumber --noconfirm --needed # provider for pipewire-session-manager
info installing pipewire-jack
sudo pacman -S pipewire-jack --noconfirm --needed # provider for jack
sudo pacman -S pipewire-alsa --noconfirm --needed # provider for alsa
sudo pacman -S pipewire-pulse --noconfirm --needed # provider for pulse

# This not working
speaker-test --test wav --channels 2 --nloop 2



section 3-minimalhalf: Setup bluetooth
info installing bluez
sudo pacman -S bluez --noconfirm --needed # Bluetooth protocol stack
sudo pacman -S bluez-utils --noconfirm --needed # For bluetoothctl
info enabling bluetooth
sudo systemctl enable bluetooth --now

section 3-minimalhalf: Setup sound
# Display Manager: Starts the X-server
info installing xorg-server
sudo pacman -S xorg-server --noconfirm --needed

cat > ~/.xinitrc << END
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi
exec tmux attach
END

info installing xinit
sudo pacman -S xorg-xinit --noconfirm --needed
info installing xterm
sudo pacman -S xterm --noconfirm --needed

echo sleep for x to be ready
sudo chvt 2
sleep 1
xterm -e tmux attach &

rm ~/.xinitrc
echo i alr slept 1 sec, should work
bash


sudo pacman -S polkit
sudo pacman -S polkit-gnome  # a graphical authenticaion agent, to be autostarted by i3


info installing lightdm
# Greeter required, can configure
sudo pacman -S lightdm lightdm-gtk-greeter --noconfirm --needed
info enabling lightdm
sudo systemctl enable lightdm
