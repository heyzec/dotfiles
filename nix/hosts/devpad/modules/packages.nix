{pkgs, ...}: {
  # Refer to https://wiki.archlinux.org/title/List_of_applications
  # A: Documents
  # B: Internet
  # C: Multimedia
  # D: Science
  # E: Security
  # F: Utilities
  # G: Other
  environment.systemPackages = let
    myPython = let
      python-packages = ps:
        with ps; [
          requests
        ];
    in
      pkgs.python3.withPackages python-packages;
  in
    with pkgs; [
      ################################################################################
      ##### Used by dotfiles
      ################################################################################
      foot # (F.1.2) terminal emulator
      rofi-wayland # (G.5.6) application launcher

      ##### To be daemonized with hyprland (via exec-once) #####
      # Clipboard
      wl-clipboard #  # (G.5.12/4) copy/paste commands (wl-copy, wl-paste)
      cliphist #      # (G.5.12/5) wayland clipboard manager
      wl-clip-persist # keep wayland clipboard even after programs close
      # System trays
      indicator-sound-switcher # sound input/output selector
      networkmanagerapplet #   # NetworkManager tray (nm-applet)
      # Others
      wob # overlay for volume and backlight

      ##### To be executed with keybinds / scripts #####
      # Backlight
      brightnessctl # (F.6.11) backlight control
      ddcutil #     # change monitor settings using DDC/CI
      # Screenshotting
      # use previous version until https://redirect.github.com/Alexays/Waybar/issues/4156 fixed
      pkgs.stable.grimblast # (C.2.13/1.1) wrapper script for grim (grab an image) and slurp (select a region)
      swappy #              # Wayland native snapshot editing tool
      # Everything else
      smile #     # (F.4.1) emoji picker
      fastfetch # # (F.6.3.1) terminal system info display
      swaybg #    # (G.5.8) wallpaper setter for wayland
      hypridle #  # idle management daemon
      libnotify # # library that provides notify-send
      playerctl # # media control

      ################################################################################
      ##### Commonly pre-installed command-line utilities
      ################################################################################
      # Hardware userspace tools
      bluez #     # (F.6.14/1.1.1) bluetooth related commands (e.g. bluetoothctl)
      lshw #      # (F.6.3.2) list hardware configuration
      pciutils #  # pci related commands (e.g. lspci)
      usbutils #  # usb related commands (e.g. lsusb)
      # Interpreters
      myPython #  # python3 interpreter with some useful packages
      # Other common command-line utilities
      imagemagick # (C.2.3.1) edit image files (e.g. convert)
      gnupg #     # (E.9.2) GNU's implementation of OpenPGP, provides gpg command
      gtk3 #      # provides a suite of commands, we need gtk-launch for launching installed .desktop files
      xdg-utils # # provides xdg-open, among other xdg-* commands

      ################################################################################
      ##### Others
      ################################################################################
      # If application is a graphical application, consider adding to home/linux/packages.nix
      # If application is a command-line utility, consider adding to modules/shell.nix

      pdfgrep # (A.6.1/4) grep text within PDFs
      rclone # (B.4.4.1) manage files on cloud storage
      btop # (F.6.1.1) TUI alternative to top
      wireguard-tools # (B.1.2) tools for configuring wireguard, a VPN protocol (e.g. wg, wg-quick)
      btdu # disk usage profiler for btrfs
      git-crypt # encrypt files in a git repository
      gocryptfs # file-based encryption as a mountable FUSE filesystem
      overskride # GUI bluetooth manager
      wl-color-picker # simple color picker with GUI
      (callPackage ../../../packages/gocryptfs-scripts.nix {})
      (python3Packages.callPackage ../../../packages/wasg.nix {})
      wayland-displays

      ##### Containerisation and Virtualisation #####
      virt-manager # frontend for qemu (virtualisation.libvirtd.enable)
      virtiofsd # additional driver for shared directory virtualisation (VMs)
    ];

  programs = {
    wireshark.enable = true;
    wireshark.package = pkgs.wireshark;

    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };

    localsend.enable = true;
  };
}
