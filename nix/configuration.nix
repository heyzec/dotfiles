# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  # home-manager = builtins.fetchTarball {
  #   url = "https://github.com/rycee/home-manager/archive/release-20.03.tar.gz";
  #   sha256 = "1xvxqw5cldlhcl7xsbw11n2s3x1h2vmbm1b9b69a641rzj3srg11";
  # };
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #/home/heyzec/test.nix
      # <home-manager/nixos>
    ];

################################################################################
##### Boot Settings
################################################################################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";

  hardware.bluetooth.enable = true;

################################################################################
##### Networking Settings
################################################################################
  networking = {
    hostName = "nixie"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        80
      ];
    };
  };

################################################################################
##### Regional Settings
################################################################################
  time.timeZone = "Asia/Singapore"; # Set your time zone.

  i18n.defaultLocale = "en_SG.UTF-8"; # Select internationalisation properties.

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_SG.UTF-8";
    LC_IDENTIFICATION = "en_SG.UTF-8";
    LC_MEASUREMENT = "en_SG.UTF-8";
    LC_MONETARY = "en_SG.UTF-8";
    LC_NAME = "en_SG.UTF-8";
    LC_NUMERIC = "en_SG.UTF-8";
    LC_PAPER = "en_SG.UTF-8";
    LC_TELEPHONE = "en_SG.UTF-8";
    LC_TIME = "en_SG.UTF-8";
  };

  environment.sessionVariables = {
    XDG_CACHE_HOME  = "$HOME/.cache";
    # rmoev this because swhkd needs assume at /etc/swhkd/swhkdrc
    # XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";
  };


################################################################################
##### System Packages
################################################################################
  environment.systemPackages = let
    # golangcl-lint 1.52.2
    reallyOld = import (pkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "ff75d77c5d6803123568981d0413606f58252a53";
      sha256 = "5UOzGnsO0cB9T2y2IazSp0GvMtiqb+85ath4Sd0M/Jk=";
    }) {};

    unstable = import <unstable> {
      config = config.nixpkgs.config; 
    };

  in with pkgs; [

    ##### Minimal requirements #####
    git
    neovim
    blackbox-terminal

    ##### Command line utilities #####
    restic              # push-based backup tool
    exiftool            # metadata reader and editor
    yt-dlp              # download youtube videos
    rclone              # manage files on cloud storage
    imagemagick         # edit image files
    openvpn             # open-source VPN
    btop
    btdu
    gnupg  # also a basic requirement for many pkgs
    wget  # also a basic requirement for many pkgs

    kanshi
    ranger
    python311



    ##### Graphical environment
    hyprland
    sddm

    dex                    # XDG autostarter
    dunst                  # notification daemon
    unstable.flameshot              # screen capture
    libnotify              # library needed for dunst, a notification daemon
    light                  # backlight control
    playerctl              # media control
    rofi-wayland           # application launcher
    swaybg                 # wallpaper setter for wayland
    swaylock               # screen locker for sway
    waybar                 # taskbar for wayland

    slurp
    grim



    ##### Applications: Standard desktop environment
    firefox-bin                # browser Mozilla based on Gecko engine
    gnome.file-roller          # archive manager
    gnome.gedit                # simple text editor
    gnome.simple-scan          # frontend for SANE
    gvfs                       # virtual filesystem with mounting and trash functionality
    vlc                        # video player
    sane-airscan               # library and CLI to use scanners
    xfce.thunar                # file manager
    xfce.thunar-volman         # volume manager integration for thunar
    xfce.thunar-archive-plugin # integration with archive tool - file-roller
    xfce.tumbler               # generate thumbnails

    # ##### Applications: Just in case
    baobab              # disk usage analyzer
    chromium            # open-source chrome
    gparted             # frontend to parted, a partitioning tool
    libvncserver        # for remmina to support VNC
    remmina             # remote desktop client
    transmission-gtk    # lightweight BitTorrent client



    ##### Applications: Documents and Graphics
    audacity         # audio editor
    inkscape         # vector graphics editor
    gimp             # image editing suite
    pdfsam-basic           # PDF editing
    xournalpp        # tablet notetaking software
    gthumb           # image viewer with simple editing tools


    ##### Applications: Communication Utilities
    telegram-desktop # Telegram client
    # discord          # Discord client
    # zoom             # Zoom client



    # [Theming]
    lxappearance        # GTK+ theme switcher
    themechanger
    # whitesur-gtk-theme  # MacOS Big Sur like theme
    # whitesur-icon-theme # MacOS Big Sur style icon theme
    vimix-icon-theme
    gnome.adwaita-icon-theme

    wayland-protocols
    qt6.qtwayland


    # [Other application package types]
    # appimagelauncher # handle AppImages
    # flatpak          # handle Flatpaks

    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true "];
      patches = (oldAttrs.patches or []) ++ [
        (pkgs.fetchpatch {
          name = "fix waybar hyprctl";
          url = "https://aur.archlinux.org/cgit/aur.git/plain/hyprctl.patch?h=waybar-hyprland-git";
          sha256 = "sha256-pY3+9Dhi61Jo2cPnBdmn3NUTSA8bAbtgsk2ooj4y7aQ=";
        })
      ];
    }))




    # [Containerisation and Virtualisation]
    qemu_full              # create virtual machines
    virt-manager           # frontend for qemu
    docker                 # run applications as a lightweight container
    docker-compose         # spin up multiple pre-configured containers
    # sudo usermod -aG docker $USERNAME
    # sudo systemctl enable --now docker


    # [Specialised CTF Tools]
    thc-hydra        # online password-cracking tool
    john             # John the Ripper, an offline password-cracker
    nmap             # port scanner
    # TODO: Fix privilege issues so that wireshark CLI is user but wireshark-cli is root
    wireshark-qt     # network analyzer


    # [Development Tools - Package and Version managers]
    python311Packages.pip # package manager for python libraries
    rbenv      # version manager tool for Ruby
    nodenv     # version manager tool for nodeJS

    # [Development Tools - Languages]
    go          # golang

    # [Development Tools - Others Tools]
    gdb         # GNU Debugger for C/C++
    valgrind    # memory leak detection tool
    # vscode # IDE-like code editor
    #unstable.vscode


    insomnia    # REST API client
    # _ mariadb     # MySQL Database
    # _ phpmyadmin  # Frontend for MariaDB and MySQL, written in PHP

    # [Unsorted]
    networkmanager-openvpn
    networkmanagerapplet
    wdisplays
    tartube
    font-manager
    qimgv

    bluez

    # clairvoyance
    zsh
    asdf-vm
    gnumake
    gcc
    gdb
    starship
    indicator-sound-switcher
    # NOTE: plocate requires a system group called plocate, or else updatedb will fail
    # this is probably a packaging error. to fix, run instructions taken from README:
    # sudo addgroup --system plocate
    plocate
    lshw
    fzf
    #keyboard
    gtk3

    # Part of the fix to make GTK apps work

    (pkgs.callPackage ./extrapackages/derivation.nix {})
    # (pkgs.callPackage ./extrapackages/clairvoyance.nix {})
    sddmtheme

    gtk4

    home-manager

    yarn
    nodejs
    postgresql
    reflex
    dbeaver

    reallyOld.golangci-lint


    wl-clipboard
    unstable.xdg-utils





# ADD
#    discord
#    fdupes
#    indicator-sound-switcher
#    ntfs-3g

  ];





################################################################################
##### Services
################################################################################
  services = {

    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "";
      displayManager.sddm = {
        enable = true;
        theme = "abstractdark";
      };
    };

    dbus.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };

    keyd = {
      enable = true;
      ids = [ "*" "-1234:5678" ];
      settings = {
        main = {
          capslock = "overload(control, esc)";

          leftalt = "layer(meta)";
          meta = "layer(alt)";

          rightalt = "layer(rightalt)";
        };


        rightalt = {
          h = "left";
          j = "down";
          k = "up";
          l = "right";
        };

      };
    };

  # udev.extraRules = ''
  #   ACTION=="add", SUBSYSTEM=="backlight", RUN+="chgrp video $sys$devpath/brightness", RUN+="chmod g+w $sys$devpath/brightness"
  # '';

    postgresql = {
      enable = true;
      package = pkgs.postgresql;
      enableTCPIP = true;
      authentication = pkgs.lib.mkOverride 10 ''
        local all all trust
        host all all 127.0.0.1/32 trust
        host all all ::1/128 trust
      '';
      initialScript = pkgs.writeText "backend-initScript" ''
        CREATE ROLE nixcloud WITH LOGIN PASSWORD 'nixcloud' CREATEDB;
        CREATE DATABASE nixcloud;
        GRANT ALL PRIVILEGES ON DATABASE nixcloud TO nixcloud;
      '';
    };

    #flatpak = {
    #  enable = true;
    #};

    # gvfs.enable = true; # Mount, trash, and other functionalities
    # tumbler.enable = true; # Thumbnail support for images

  };


  # Configure keymap in X11
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';
  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c /home/heyzec/.config/kanshi/config'';
    };
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

################################################################################
##### Programs
################################################################################
  programs = {

    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
    };

    zsh = {
      enable = true;
    };

    waybar = {
      enable = true;
        # See https://github.com/hyprwm/Hyprland/issues/725#issuecomment-1541364919
        package = pkgs.waybar.overrideAttrs (oa: {
        mesonFlags = (oa.mesonFlags or  []) ++ [ "-Dexperimental=true" ];
        patches = (oa.patches or []) ++ [
          (pkgs.fetchpatch {
            name = "fix waybar hyprctl";
            url = "https://aur.archlinux.org/cgit/aur.git/plain/hyprctl.patch?h=waybar-hyprland-git";
            sha256 = "sha256-pY3+9Dhi61Jo2cPnBdmn3NUTSA8bAbtgsk2ooj4y7aQ=";
          })
        ];
      });
    };

    #thunar.plugins = with pkgs.xfce; [
    #  thunar-archive-plugin
    #  thunar-volman
    #];

  };

  environment.etc."asdf-vm/asdf.sh".source = "${pkgs.asdf-vm}/share/asdf-vm/asdf.sh";

################################################################################
##### Fonts
################################################################################
  fonts = {
    fonts = with pkgs; [
      roboto             # Google\'s sans-serif fonts
      roboto-mono        # Google\'s sans-serif monospace font
      noto-fonts             # Google\'s fonts
      noto-fonts-emoji       # Google\'s open-source Emoji 14.0
    ];
    fontconfig.enable = true;
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [ "Noto Sans" ];
      # also set monospace and emoji
    };
  };

################################################################################
##### Hardware settings
################################################################################

################################################################################
##### User Accounts
################################################################################
  users.users.heyzec = {
    isNormalUser = true;
    description = "heyzec";
    extraGroups = [
      "wheel"            # Access sudo command
      "networkmanager"   # Access network manager
      "input"
      "video"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

################################################################################
##### Nix Configuration
################################################################################

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    # nix.settings.substituters = [ "https://aseipp-nix-cache.global.ssl.fastly.net" ];
    # nix.binaryCaches = [ "https://aseipp-nix-cache.global.ssl.fastly.net" ];
  };
  nixpkgs = {
    config.allowUnfree = true; # Allow unfree packages
    # config.packageOverrides = pkgs: rec { sddmtheme = pkgs.callPackage ./extrapackages/SDDMTheme.nix {}; };
      overlays = [
        (import ./overlays/packages.nix)
      ];
  };



  xdg.portal = {
      enable = true;
      xdgOpenUsePortal = false;
      extraPortals = with pkgs; [
          xdg-desktop-portal-wlr
          # is a fork of hyprland
          xdg-desktop-portal-gtk
          xdg-desktop-portal-hyprland
      ];
      wlr = {
          enable = true;
      };
  };

  xdg.mime.enable = true;
  xdg.mime.defaultApplications = {
      "inode/directory" = "thunar.desktop";
      "text/x-uri" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
  };


  security.polkit.enable = true;
  security.polkit.debug = true;

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "com.github.swhkd.pkexec"  &&
            subject.local == true &&
            subject.active == true &&) {
                return polkit.Result.YES;
        }
    });
  '';
  security.pam.services.swaylock = {};


  ## Docker

  virtualisation = {
    docker.enable = true;
  };


    # home-manager.users.heyzec = { pkgs, ...}: {
    #   home.packages = [];
    # };




 # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

# Enable all sysrq functions (useful to recover from some issues):
  boot.kernel.sysctl."kernel.sysrq" = 1; # NixOS default: 16 (only the sync command)

  # NixOS System Version (Do not touch!!)
  system.stateVersion = "23.05";

}
# vim: set ts=2 sts=2 sw=2:
