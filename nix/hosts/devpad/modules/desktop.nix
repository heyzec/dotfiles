{pkgs, ...}: {
  # Applications commonly pre-installed on desktop environments
  # If NixOS provides a module, use it
  environment.systemPackages = with pkgs;
    [
      gnome-text-editor #  # (A.1.4) simple text editor
      libreoffice-qt #     # (A.2.1) alternative to MS Office
      mate.atril #         # (A.6.1/2.2) simple pdf viewer
      simple-scan #        # (A.8/1.2) frontend for SANE
      chromium #           # (B.2.2.2) open-source chrome
      transmission_4-gtk # # (B.4.6.2) lightweight BitTorrent client
      remmina #            # (B.7.1) remote desktop client
      qimgv #              # (C.2.1.3) simple image viewer
      gthumb #             # (C.2.2) image viewer with simple editing tools
      vlc #                # (C.4.1.2.3) video player
      # xfce.thunar #      # (F.2.1.2) file manager
      gparted #            # (F.5.1/3.1.1) frontend to parted, a partitioning tool
      baobab #             # (F.5.5.2) disk usage analyzer
      font-manager #       # (F.6.5) easily manage desktop fonts
    ]
    ++ [
      # Fix for kde-open5: command not found when opening links in libreoffice
      (pkgs.writeShellScriptBin "kde-open5" ''
        xdg-open "$@"
      '')
    ];

  # Has dbus services (added to services.dbus.packages)
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin # integration with archive tool - file-roller
      thunar-volman #       # volume manager integration for thunar
      tumbler #             # generate thumbnails
    ];
  };
  # Soft dependency for thunar (e.g. trash, removable media, remote FS)
  services.gvfs.enable = true;

  # Transmission has a module but it's for daemon
}
