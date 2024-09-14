{ pkgs, ... }: {
  # https://github.com/NixOS/nixpkgs/issues/216361
  # Packages here can break if nixpkgs-unstable goes out of sync with home manager master
  home.packages = with pkgs; [
    # Organised by https://wiki.archlinux.org/title/List_of_applications

    # Documents: 2.5. Database Tools
    dbeaver-bin

    # Documents: 6.1. PDF and DjVu: 3.2. Basic editors
    pdfsam-basic # PDF editor with merging, splitting and rotating

    # Documents: 10.1.2. Note-taking software (Graphical)
    joplin-desktop
    obsidian

    # Documents: 10.1.3. Note-taking software (Stylus note-taking)
    xournalpp        # tablet notetaking software

    # Internet: 5.5.9. Instant messaging clients (Other IM clients)
    slack
    teams-for-linux
    telegram-desktop-gtk  # Telegram client (patched to use GTK3 over QT filepicker, see overlays)
    webcord               # Alternative Discord client
    whatsapp-for-linux    # unofficial client
    # zoom              # Zoom client

    # Other: 1.6.2 Task management (Graphical)
    ticktick


    # UNCATEGORISED
    bottles
    insomnia    # REST API client
    john             # John the Ripper, an offline password-cracker
    linux-wifi-hotspot
    mindustry
    tectonic
    thc-hydra        # online password-cracking tool
    waypaper
  ];
}

