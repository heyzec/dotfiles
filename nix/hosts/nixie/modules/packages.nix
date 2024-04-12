{ config, pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    ################################################################################
    ##### Command-line Utilities
    ################################################################################

    ##### Command line utilities: Basics #####
    git
    gnupg
    wget
    zip unzip
    tmux

    ##### Command line utilities: Hardware drivers related #####
    bluez               # bluetooth related commands (e.g. bluetoothctl)
    brightnessctl       # backlight control
    ddcutil             # change monitor settings using DDC/CI
    light               # backlight control
    lshw                # list hardware configuration
    ntfs3g              # for ntfs
    pciutils            # pci related commands (e.g. lspci)
    usbutils            # usb related commands (e.g. lsusb)
    virtiofsd           # additional driver for shared directory virtualisation (VMs)

    ##### Command line utilities: Terminal #####
    ctpv                # file previewer for lf, with image support
    lf                  # terminal file manager
    neofetch            # terminal system info display
    nix-output-monitor  # prettify nix command outputs

    ##### Command line utilities: System #####
    btdu                # disk usage profiler for btrfs
    btop                # better top

    ##### Command line utilities: Downloads, Backups, Encryption #####
    git-crypt           # encrypt files in a git repository
    gocryptfs           # file-based encryption as a mountable FUSE filesystem
    rclone              # manage files on cloud storage
    restic              # push-based backup tool
    wireguard-tools     # tools for configuring wireguard, a VPN protocol (e.g. wg, wg-quick)
    yt-dlp              # download youtube videos

    ##### Command line utilities: Network Diagnostics #####
    nmap                # port scanner
    traceroute          # track route taken by packets

    ##### Command line utilities: Others #####
    imagemagick         # edit image files (e.g. convert)
    kanshi              # dynamic display configuration tool
    pdfgrep             # grep text within PDFs


    man-pages man-pages-posix # Additional man pages


    ################################################################################
    ##### Graphical / Desktop Environment
    ################################################################################

    ##### Graphical environment
    dex                    # XDG autostarter
    dunst                  # notification daemon
    foot                   # terminal emulator
    hypridle               # idle management daemon
    libnotify              # library needed for dunst, a notification daemon
    playerctl              # media control
    rofi-wayland           # application launcher
    swaybg                 # wallpaper setter for wayland
    swaylock-effects       # screen locker for sway
    wlogout                # logout menu

    # flameshot               # screen capture
    grim                   # grab an image
    slurp                  # select a region
    swappy                 # Wayland native snapshot editing tool

    cliphist               # wayland clipboard manager
    wl-clip-persist        # keep wayland clipboard even after programs close
    wl-clipboard           # copy/paste commands (wl-copy, wl-paste)

    wob                    # overlay for volume and backlight
    gtk3                   # provides a suite of commands, we need gtk-launch for launching installed .desktop files

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
    font-manager         # easily manage desktop fonts
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

    ##### Documents and Graphics #####
    audacity         # audio editor
    gimp             # image editing suite
    inkscape         # vector graphics editor
    libreoffice-qt   # alternative to MS Office
    vscode           # IDE-like text editor

    ##### Others #####
    cryptor             # frontend for gocryptfs
    wayland-protocols
    tartube             # frontend for youtube-dl

    ##### Other application package types #####
    appimage-run
    flatpak           # handle Flatpaks

    ##### Containerisation and Virtualisation #####
    qemu_full              # create virtual machines
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

    xdg-utils
    wl-mirror
    freerdp
    pdfarranger
    # mission-center
    # etcher (disabled until updated)
  ];
}
