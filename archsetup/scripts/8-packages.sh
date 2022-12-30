#!/usr/bin/env bash


_ [Complete graphical environment]
_ picom           : Xorg Desktop compositor
_ libnotify       : library needed for dunst, a notification daemon
_ dunst           : notification daemon
_ i3lock-color    : screen locker
_ rofi            : application launcher
_ light           : backlight control
_ playerctl       : media control
_ flameshot       : screen capture
_ xwallpaper      : wallpaper setter
_ polybar         : taskbar

sudo usermod -aG video $USERNAME


_ [Standard desktop environment applications]
_ firefox          : browser Mozilla based on Gecko engine
_ gedit            : simple text editor
_ thunar           : file manager
_ vlc              : video player
_ sane             : library and CLI to use scanners
_ simple-scan      : frontend for SANE


_ [Utilities]
_ gparted             : frontend to parted, a partitioning tool
_ wireshark-qt        : network analyzer
_ youtube-dl          : download youtube videos
_ baobab              : disk usage analyzer
_ remmina             : remote desktop client
_ libvncserver        : for remmina to support VNC
_ perl-image-exiftool : metadata reader and editor
_ restic              : push-based backup tool
_ file-roller         : archive manager


_ [Graphics]
_ inkscape         : vector graphics editor
_ gimp             : image editing suite


_ [Documents]
_ audacity         : audio editor
_ xournalpp        : tablet notetaking software
_ pdfsam           : PDF editing
_ neovim           : CLI editor


_ [Others]
_ qemu-full              : create virtual machines
_ virt-manager           : frontend for qemu
_ visual-studio-code-bin : IDE-like code editor
_ docker                 : run applications as a lightweight container
_ docker-compose         : spin up multiple pre-configured containers
sudo usermod -aG docker $USERNAME
sudo systemctl enable --now docker
_ telegram-desktop       : Telegram client
_ python-pip             : package manager for python libraries
_ chromium               : open-source chrome

_ [Fonts]
_ ttf-roboto             : Google\'s sans-serif fonts
_ ttf-roboto-mono        : Google\'s sans-serif monospace font
_ noto-fonts             : Google\'s icons Emoji library


_ [Other application package types]
_ appimagelauncher : handle AppImages
_ flatpak          : handle Flatpaks





# Commented out cuz this is taking too long
# flatpak install flathub org.telegram.desktop

# Fix privilege issues so that wireshark CLI is user but wireshark-cli is root
#
#
