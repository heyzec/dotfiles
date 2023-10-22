# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:
let
in {
  # Enabling waybar to use different channel
  # See https://github.com/NixOS/nixpkgs/issues/41212

################################################################################
##### Nix Configuration
################################################################################

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    settings.auto-optimise-store = true;  # hard links duplicate files
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
  nixpkgs.config.allowUnfree = true;

# 1. HARDWARE, BOOT, NETWORK SETTINGS {{{
################################################################################
##### Hardware settings
################################################################################

################################################################################
##### Boot Settings
################################################################################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";
  boot.kernelPackages = pkgs.stable.linuxPackages;
  boot.kernelParams = [
    "\"PARTLABEL=Swap partition\""
  ];
  # Enable all sysrq functions (useful to recover from some issues):
  boot.kernel.sysctl."kernel.sysrq" = 1; # NixOS default: 16 (only the sync command)

  # To cross-compile
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  # Enable boot splash
  boot.plymouth.enable = true;

  boot.initrd.kernelModules = [
    # Early KMS for plymouth to start earlier
    # https://wiki.archlinux.org/title/Kernel_mode_setting#Early_KMS_start
    "i915"
  ];

  hardware = {
    bluetooth.enable = true;
    uinput.enable = true;
    i2c.enable = true;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        libvdpau-va-gl
      ];
    };
  };

  hardware.sane = {
    enable = true; extraBackends = [ pkgs.utsushi ];
  };
  # use epsonscan nexttime
  services.udev.packages = [ pkgs.utsushi ];

################################################################################
##### Networking Settings
################################################################################
  networking = {
    hostName = "nixie"; # Define your hostname.
    networkmanager.enable = true;
    firewall = {
      enable = false;
      allowedTCPPorts = [
        80
      ];
    };
  };

################################################################################
##### Regional Settings
################################################################################
  time.timeZone = "Asia/Singapore";
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
    # XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME   = "$HOME/.local/share";
    XDG_STATE_HOME  = "$HOME/.local/state";
    # Hint electron apps to use wayland
    # BREAKS VSCODE
    # NIXOS_OZONE_WL = "1";
  };
# }}}

# 2. USER ACCOUNTS {{{
################################################################################
##### User Accounts
################################################################################
  users.mutableUsers = false;
  users.users.heyzec = {
    isNormalUser = true;
    uid = 1000;
    description = "heyzec";
    extraGroups = [
      "wheel"            # Access sudo command
      "networkmanager"   # Access network manager
      "uinput"
      "input"
      "video"
      "docker"
      "libvirtd"
      "plocate"
      "ic2"              # Control /dev/i2c-* devices
      "wireshark"
    ];
    shell = pkgs.zsh;
    hashedPassword = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
  };
# }}}

# 3. CONFIGURED PROGRAMS {{{
################################################################################
##### Programs
################################################################################
  programs = {
    nix-ld.enable = true;
    dconf.enable = true;

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

    firefox = {
      enable = true;
      nativeMessagingHosts.tridactyl = true;
    };


    # xfce.thunar                # file manager
    # xfce.thunar-volman         # volume manager integration for thunar
    # xfce.thunar-archive-plugin # integration with archive tool - file-roller
    # xfce.tumbler               # generate thumbnails
    thunar.enable = true;               # file manager
    thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin             # integration with archive tool - file-roller
      thunar-volman                     # volume manager integration for thunar
      tumbler               # generate thumbnails
    ];

    file-roller.enable = true;

    wireshark.enable = true;
    wireshark.package = pkgs.wireshark;

  };

  environment.etc."asdf-vm/asdf.sh".source = "${pkgs.asdf-vm}/share/asdf-vm/asdf.sh";
# }}}

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

    (pkgs.callPackage ./extrapackages/swhkd/default.nix {})  # self-packaged swhkd

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

# 5. SERVICES AND SYSTEMD {{{
################################################################################
##### Services and SystemD
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

    dbus = {
      enable = true;
      packages = [ pkgs.flameshot ];
    };



    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };

 #    udev.extraRules = ''
 #        KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
 #  '';


    keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" "-1234:5678" ];
          settings = {
            main = {
              capslock = "overload(arrow, esc)";

              leftalt = "layer(meta)";
              meta = "layer(alt)";
            };
            arrow = {
              h = "left";
              j = "down";
              k = "up";
              l = "right";
            };
          };
        };
      };
    };

    auto-cpufreq.enable = true;

    logind.extraConfig = ''
      # don’t shutdown when power button is short-pressed
      HandlePowerKey=ignore
    '';

    earlyoom = {
      enable = true;
      extraArgs = [
        "--avoid '^(Hyprland)$'"
        "--prefer '^(electron)$'"
      ];
    };

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

    flatpak = {
      enable = true;
    };

    # tumbler.enable = true; # Thumbnail support for images

    # For automounting
    devmon.enable = true;
    gvfs.enable = true; # Mount, trash, and other functionalities
    udisks2.enable = true;

    avahi = {
      enable = true;
      nssmdns = true;
    };
    printing.enable = true;

    cron.enable = true;  # Temporary, until we migrate all to systemd timers

    btrbk = {
      # Name instance to be "btrbk" to generate config at default location.
      instances."btrbk" = {
        onCalendar = "*-*-* 22:00:00";
        settings = {
        # ssh_identity = "/home/heyzec/.ssh/id_ed25519";
        ssh_user = "btrbk";
          volume."/mnt/D" = {
            snapshot_preserve_min = "latest";
            snapshot_preserve = "7d 4w 1m";

            subvolume = "@data";
            snapshot_dir = "@snapshots";
            target = "ssh://heyzec.mooo.com:40478/media/backups/btrbk";
          };
        };
      };
    };

    locate = {
      enable = true;
      locate = pkgs.plocate;
      localuser = null;  # to squelch warning: plocate does not support non-root updatedb
      pruneNames = [
        ".bzr" ".cache" ".git" ".hg" ".svn"  # defaults
        "node_modules"
        "@snapshots"
        "/mnt/D" # Prefer /media/D
      ];
    };

    # Enable the OpenSSH daemon.
    openssh.enable = true;

    thermald.enable = true;
  };


  systemd = {
    user.services.kanshi = {
      description = "kanshi daemon";
      serviceConfig = {
        Type = "simple";
        ExecStart = ''${pkgs.kanshi}/bin/kanshi'';
      };
    };
  };

# }}}

# 6. OTHERS {{{
################################################################################
##### Fonts
################################################################################
  fonts = {
    packages = with pkgs; [
      roboto             # Google's sans-serif fonts
      roboto-mono        # Google's sans-serif monospace font
      noto-fonts         # Google's fonts
      noto-fonts-emoji   # Google's open-source Emoji 14.0

      # Only install a selection of fonts from nerdfonts repository
      (nerdfonts.override { fonts = [ "RobotoMono" ]; })
    ];
    fontconfig.enable = true;
    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" ];
      sansSerif = [ "Noto Sans" ];
      monospace = [ "Noto Sans Mono" ];
      # also set monospace and emoji
    };
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
      wlr.enable = true;
  };

  xdg.mime.enable = true;



  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "com.github.swhkd.pkexec"  &&
            subject.local == true &&
            subject.active == true &&) {
                return polkit.Result.YES;
        }
    });
  '';

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  documentation.dev.enable = true;



 # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;


  # NixOS System Version (Do not touch!!)
  system.stateVersion = "23.05";


  # services.xremap = {
  #   withHypr = true;
  #   serviceMode = "user";
  #   userName = "heyzec";
  #   watch = true;
  #   config = {
  #     modmap = [
  #       {
  #         remap = {
  #           KEY_LEFTALT = "KEY_LEFTMETA";
  #           KEY_LEFTMETA = "KEY_LEFTALT";
  #         };
  #       }
  #     ];
  #     keymap = [
  #       {
  #         remap = {
  #           super-y = {
  #             launch = [ "firefox" ];
  #           };
  #         };
  #       }
  #     ];
  #   };
  # };

# }}}

}
# vim: set ts=2 sts=2 sw=2:

