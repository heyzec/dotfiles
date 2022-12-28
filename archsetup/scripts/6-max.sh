
# 6. Complete graphcical enviromnet 2 - Apps
# Install appimage to handle
sudo yay -S appimagelauncher --noconfirm --needed
# see whehter can script the config of this w

sudo pacman -S flatpak --noconfirm --needed

# nautilus, simple-scan, 
# COmmented out cuz this is taking too long
# flatpak install flathub org.telegram.desktop


sudo pacman -S inkscape --noconfirm --needed
sudo pacman -S gimp --noconfirm --needed

sudo pacman -S gparted --noconfirm --needed
sudo pacman -S youtube-dl --noconfirm --needed
sudo pacman -S xournalpp --noconfirm --needed
sudo pacman -S wireshark-qt --noconfirm --needed
# Fix privilege issues so that wireshark CLI is user but wireshark-cli is root
