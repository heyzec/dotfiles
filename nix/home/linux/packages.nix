{pkgs, ...}: {
  # Refer to https://wiki.archlinux.org/title/List_of_applications
  # A: Documents
  # B: Internet
  # C: Multimedia
  # D: Science
  # E: Security
  # F: Utilities
  # G: Other
  home.packages = with pkgs; [
    ##### A. Documents #####
    dbeaver-bin # (A.2.5) graphical database management tool
    pdfsam-basic #         # (A.6.1/3.2) PDF editor with merging, splitting and rotating
    # (A.10.1.2) Note-taking software (Graphical)
    joplin-desktop
    obsidian

    ##### B. Internet #####
    # (B.5.5.9) Instant messaging clients (Other IM clients)
    telegram-desktop-gtk # # Telegram client (patched to use GTK3 over QT filepicker, see overlays)
    wasistlos #            # unofficial client
    webcord #              # Alternative Discord client
    teams-for-linux
    zoom

    tartube-yt-dlp # (B.4.1.2) frontend for yt-dlp, a maintained fork of youtube-dl
    yt-dlp # (B.4.1.1) download youtube videos

    linux-wifi-hotspot

    ##### C. Multimedia #####
    gimp3 #  # (C.2.5) raster image editor
    inkscape # (C.2.8) vector graphics editor
    audacity # (C.3.8) audio editor

    ##### F. Utilities #####
    # (F.3) Development
    bruno # REST API client

    bottles # (F.6.21) graphical Wine manager

    ##### G. Other #####
    ticktick # (G.1.6.2) graphical task management

    ##### Games #####
    mindustry
  ];

  # https://github.com/NixOS/nixpkgs/issues/216361
  # Packages here can break if nixpkgs-unstable goes out of sync with home manager master
}
