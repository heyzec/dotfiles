{ config, pkgs, inputs, ... }: {
# 4. ADDITIONAL SYSTEM PACKAGES {{{
################################################################################
##### System Packages
################################################################################
  environment.systemPackages = let
  in with pkgs; [

    ##### Minimal requirements #####
    git
    neovim
    foot

    ##### Command line utilities #####
    btdu
    gnupg  # also a basic requirement for many pkgs
    wget  # also a basic requirement for many pkgs
    zip
    unzip
    gnumake
    gcc

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
    exiftool            # metadata reader and editor
    yt-dlp              # download youtube videos
    rclone              # manage files on cloud storage
    imagemagick         # edit image files
    openvpn             # open-source VPN
    btop
    kanshi
    neofetch
    comma

    man-pages man-pages-posix # Additional man pages

    # Using newer version of sddm, else it hangs on shutdown
    # https://bbs.archlinux.org/viewtopic.php?pid=2099914#p2099914
    # unstable.sddm



    # using latest for sixel support
    (lf.override {
    # See note for overriding Go packages:
    # https://github.com/NixOS/nixpkgs/issues/86349#issuecomment-945210042
      buildGoModule = args: pkgs.buildGoModule ( args // {
        src = fetchFromGitHub {
          owner = "gokcehan";
          repo = "lf";
          rev = "r31";
          sha256 = "sha256-Tuk/4R/gGtSY+4M/+OhQCbhXftZGoxZ0SeLIwYjTLA4=";
        };
        vendorHash = "sha256-PVvHrXfMN6ZSWqd5GJ08VaeKaHrFsz6FKdDoe0tk2BE=";
      });
    })
    # two dependencies for the lf previewer
    file
    chafa


    (let
      python-packages = ps: with ps; [
        python-dotenv
        requests
        python-telegram-bot
      ];
    in
      python311.withPackages python-packages)
    python311Packages.pip # package manager for python libraries

    distrobox

    ##### Graphical environment
    # Using newer version of sddm, else it hangs on shutdown
    # https://bbs.archlinux.org/viewtopic.php?pid=2099914#p2099914
    # unstable.sddm

    dex                    # XDG autostarter
    dunst                  # notification daemon
    # flameshot              # screen capture
    # unstable.flameshot              # screen capture
    libnotify              # library needed for dunst, a notification daemon
    playerctl              # media control
    rofi-wayland           # application launcher
    swaybg                 # wallpaper setter for wayland
    swaylock-effects       # screen locker for sway
    swayidle
    wlogout

    slurp
    grim
    swappy



    ##### Applications: Standard desktop environment
    baobab               # disk usage analyzer
    chromium             # open-source chrome
    gnome-text-editor    # simple text editor
    gnome.simple-scan    # frontend for SANE
    gparted              # frontend to parted, a partitioning tool
    gthumb               # image viewer with simple editing tools
    libvncserver         # for remmina to support VNC
    mate.atril           # simple pdf viewer
    qimgv
    remmina              # remote desktop client
    sane-airscan         # library and CLI to use scanners
    transmission-gtk     # lightweight BitTorrent client
    vlc                  # video player
    xfce.tumbler         # generate thumbnails
    font-manager



    ##### Applications: Documents and Graphics
    audacity         # audio editor
    inkscape         # vector graphics editor
    gimp             # image editing suite
    # Use stable for now because electron apps broken
    vscode # IDE-like text editor
    libreoffice-qt




    # [Theming]
    lxappearance        # GTK+ theme switcher
    themechanger
    # whitesur-gtk-theme  # MacOS Big Sur like theme
    # whitesur-icon-theme # MacOS Big Sur style icon theme
    vimix-icon-theme
    gnome.adwaita-icon-theme

    wayland-protocols


    # [Other application package types]
    appimage-run
    flatpak          # handle Flatpaks
    # [Containerisation and Virtualisation]
    qemu_full              # create virtual machines
    #libvirt
    virt-manager           # frontend for qemu


    ##### Development Tools: Languages, package and version managers #####
    rbenv      # version manager tool for Ruby
    nodenv     # version manager tool for nodeJS
    yarn
    nodejs
    go          # golang
    asdf-vm

    # [Development Tools - Others Tools]
    gdb         # GNU Debugger for C/C++
    valgrind    # memory leak detection tool



    # [Unsorted]
    indicator-sound-switcher
    networkmanager-openvpn
    networkmanagerapplet
    wdisplays
    tartube

    starship
    indicator-sound-switcher
    fzf

    (pkgs.callPackage ../packages/swhkd/default.nix {})  # self-packaged swhkd

    # sddmtheme is defined in overlay
    # sddmtheme
    # These are two dependencies required by the sugar-dark theme.
    # Would be nice if can package together.
    libsForQt5.qt5.qtquickcontrols2
    libsForQt5.qt5.qtgraphicaleffects


    gtk2
    gtk3
    gtk4
    qt5.qtwayland
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    adwaita-qt6


    # golangcl-lint 1.52.2
    # reallyOld = import (pkgs.fetchFromGitHub {
    #   owner = "NixOS";
    #   repo = "nixpkgs";
    #   rev = "ff75d77c5d6803123568981d0413606f58252a53";
    #   sha256 = "5UOzGnsO0cB9T2y2IazSp0GvMtiqb+85ath4Sd0M/Jk=";
    # }) {};
    golangci-lint


    wl-clipboard
    copyq
    xdg-utils
    wob
    wl-mirror
    freerdp
    # mission-center
  # etcher
  ];

# }}}
}
