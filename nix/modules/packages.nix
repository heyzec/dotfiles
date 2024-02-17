{ config, pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    ################################################################################
    ##### Command-line Utilities
    ################################################################################

    ##### Basic command line utilities #####
    git
    gnupg  # also a basic requirement for many pkgs
    wget   # also a basic requirement for many pkgs
    zip
    unzip

    ##### User space drivers and utilities #####
    pciutils
    bluez
    lshw
    usbutils
    ntfs3g
    brightnessctl
    virtiofsd # Additional Dirvers for virtrualisation
    light                  # backlight control
    ddcutil

    ##### Command line utilities 2 #####
    restic              # push-based backup tool
    yt-dlp              # download youtube videos
    rclone              # manage files on cloud storage
    imagemagick         # edit image files
    openvpn             # open-source VPN
    btop                # better top
    btdu                # disk usage profiler for btrfs
    kanshi
    neofetch
    lf                  # terminal file manager
    ctpv                # file previewer for lf, with image support

    man-pages man-pages-posix # Additional man pages




    ################################################################################
    ##### Graphical / Desktop Environment
    ################################################################################

    ##### Graphical environment
    # Using newer version of sddm, else it hangs on shutdown
    # https://bbs.archlinux.org/viewtopic.php?pid=2099914#p2099914
    # unstable.sddm

    dex                    # XDG autostarter
    dunst                  # notification daemon
    # flameshot              # screen capture
    libnotify              # library needed for dunst, a notification daemon
    playerctl              # media control
    rofi-wayland           # application launcher
    swaybg                 # wallpaper setter for wayland
    swaylock-effects       # screen locker for sway
    swayidle               # idle management daemon
    wlogout                # logout menu
    foot                   # terminal emulator

    slurp
    grim
    swappy

    wl-clipboard
    cliphist
    wl-clip-persist

    wob                        # overlay for volume and backlight

    ##### System trays #####
    indicator-sound-switcher   # sound input/output selector
    networkmanagerapplet       # NetworkManager
    networkmanager-openvpn     # enable/disable OpenVPN profiles

    ##### Theming #####
    lxappearance        # GTK+ theme switcher
    themechanger
    # whitesur-gtk-theme  # MacOS Big Sur like theme
    # whitesur-icon-theme # MacOS Big Sur style icon theme
    vimix-icon-theme
    gnome.adwaita-icon-theme


    ################################################################################
    ##### Applications
    ################################################################################

    ##### Standard desktop environment #####
    baobab               # disk usage analyzer
    chromium             # open-source chrome
    gnome-text-editor    # simple text editor
    gnome.simple-scan    # frontend for SANE
    gparted              # frontend to parted, a partitioning tool
    gthumb               # image viewer with simple editing tools
    libvncserver         # for remmina to support VNC
    mate.atril           # simple pdf viewer
    overskride           # GUI bluetooth manager
    qimgv                # simple image viewer
    remmina              # remote desktop client
    sane-airscan         # library and CLI to use scanners
    transmission-gtk     # lightweight BitTorrent client
    vlc                  # video player
    font-manager

    ##### Documents and Graphics #####
    audacity         # audio editor
    inkscape         # vector graphics editor
    gimp             # image editing suite
    vscode           # IDE-like text editor
    libreoffice-qt



    gocryptfs
    cryptor


    wayland-protocols


    # [Other application package types]
    appimage-run
    flatpak          # handle Flatpaks
    # [Containerisation and Virtualisation]
    qemu_full              # create virtual machines
    #libvirt
    virt-manager           # frontend for qemu
    distrobox


    ################################################################################
    ##### Development Tools
    ################################################################################

    ##### Python-specific #####
    (let
      python-packages = ps: with ps; [
        python-dotenv
        requests
        python-telegram-bot
      ];
    in
      python311.withPackages python-packages)
    python311Packages.pip # package manager for python libraries

    ##### Languages, package and version managers #####
    gnumake
    gcc
    # rbenv      # version manager tool for Ruby
    # nodenv     # version manager tool for nodeJS
    # yarn
    # nodejs
    go          # golang
    asdf-vm
    clang-tools_16  # for C++ LSP - clangd

    ##### Other Tools #####
    gdb         # GNU Debugger for C/C++
    valgrind    # memory leak detection tool



    ################################################################################
    ##### Unsorted
    ################################################################################
    wdisplays
    tartube
    git-crypt
    mindustry
    slack

    xdg-utils
    wl-mirror
    freerdp
    pdfarranger
    # mission-center
  # etcher
  ];
}
