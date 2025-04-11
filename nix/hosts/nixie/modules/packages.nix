{ config, pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    # TODO: Not to see command-line utils as different as GUI
    # E.g. btop may be command line, but it is used more like a GUI because it is not
    # used as part of a script somewhere else in my system

    ################################################################################
    ##### Command-line Utilities
    ################################################################################

    ##### Command line utilities: Basics #####
    gnupg

    ##### Command line utilities: Hardware drivers related #####
    bluez               # bluetooth related commands (e.g. bluetoothctl)
    brightnessctl       # (F.6.11) backlight control
    ddcutil             # change monitor settings using DDC/CI
    light               # (F.6.11) backlight control
    lshw                # list hardware configuration
    pciutils            # pci related commands (e.g. lspci)
    usbutils            # usb related commands (e.g. lsusb)
    virtiofsd           # additional driver for shared directory virtualisation (VMs)

    ##### Command line utilities: Terminal #####
    fastfetch           # (F.6.3.1) terminal system info display

    ##### Command line utilities: System #####
    btdu                # disk usage profiler for btrfs
    btop                # (F.6.1.1) better top

    ##### Command line utilities: Downloads, Backups, Encryption #####
    git-crypt           # encrypt files in a git repository
    gocryptfs           # file-based encryption as a mountable FUSE filesystem
    (callPackage ../../../packages/gocryptfs-scripts.nix {})
    (python3Packages.callPackage ../../../packages/wasg.nix {})
    rclone              # (B.4.4.1) manage files on cloud storage
    wireguard-tools     # (B.1.2) tools for configuring wireguard, a VPN protocol (e.g. wg, wg-quick)
    yt-dlp              # (B.4.1.1) download youtube videos


    ##### Command line utilities: Others #####
    imagemagick         # (C.2.3.1) edit image files (e.g. convert)
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
    smile                  # (F.4.1) emoji picker
    swaybg                 # wallpaper setter for wayland
    # wlogout                # logout menu

    # flameshot               # screen capture
    grimblast              # (C.2.13/1.1) wrapper script for grim (grab an image) and slurp (select a region)
    swappy                 # Wayland native snapshot editing tool

    cliphist               # wayland clipboard manager
    wl-clip-persist        # keep wayland clipboard even after programs close
    wl-clipboard           # copy/paste commands (wl-copy, wl-paste)

    wob                    # overlay for volume and backlight
    gtk3                   # provides a suite of commands, we need gtk-launch for launching installed .desktop files

    ##### System trays #####
    indicator-sound-switcher   # sound input/output selector
    networkmanagerapplet       # NetworkManager

    ##### Theming #####
    lxappearance        # GTK+ theme switcher
    themechanger


    ################################################################################
    ##### Applications
    ################################################################################



    ##### Standard desktop environment #####
    baobab               # (F.5.5.2) disk usage analyzer
    chromium             # (B.2.2.2) open-source chrome
    font-manager         # (F.6.5) easily manage desktop fonts
    gnome-text-editor    # (A.1.4) simple text editor
    simple-scan          # frontend for SANE
    gparted              # (F.5.1/3.1.1) frontend to parted, a partitioning tool
    gthumb               # (C.2.2) image viewer with simple editing tools
    libvncserver         # for remmina to support VNC
    mate.atril           # (A.6.1/2.2) simple pdf viewer
    overskride           # GUI bluetooth manager
    qimgv                # (C.2.1.3) simple image viewer
    remmina              # (B.7.1) remote desktop client
    transmission_4-gtk   # (B.4.6.2) lightweight BitTorrent client
    vlc                  # (C.4.1.2.3) video player

    # C.2.5 Multimedia - Raster graphics editors
    gimp             # image editing suite
    # C.2.8 Multimedia - Vector graphics editors
    inkscape         # vector graphics editor
    # C.3.8 Multimedia - Audio editors
    audacity         # audio editor


    ##### Documents and Graphics #####
    libreoffice-qt   # (A.2.1) alternative to MS Office
    # Fix for kde-open5: command not found when opening links in libreoffice
    (pkgs.writeShellScriptBin "kde-open5" ''
      xdg-open "$@"
    '')

    ##### Others #####
    cryptor             # frontend for gocryptfs
    tartube-yt-dlp      # (B.4.1.2) frontend for yt-dlp, a maintained fork of youtube-dl

    ##### Other application package types #####
    appimage-run
    # TODO: See services.flatpak.enable alone is able work
    # flatpak           # handle Flatpaks

    ##### Containerisation and Virtualisation #####
    qemu                   # create virtual machines
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
      python3.withPackages python-packages)
    python3Packages.pip # package manager for python libraries

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

  programs = {
    wireshark.enable = true;
    wireshark.package = pkgs.wireshark;
  };
}
