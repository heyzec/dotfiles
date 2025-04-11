{ pkgs, ... }: {
  # https://github.com/NixOS/nixpkgs/issues/216361
  # Packages here can break if nixpkgs-unstable goes out of sync with home manager master
  home.packages = with pkgs; [

    # A.2.5. Documents - Database Tools
    dbeaver-bin

    # A.6.1/3.2. Documents: PDF and DjVu: Basic editors
    pdfsam-basic #         # PDF editor with merging, splitting and rotating

    # A.10.1.2. Documents - Note-taking software (Graphical)
    joplin-desktop
    obsidian

    # A.10.1.3. Documents - Note-taking software (Stylus note-taking)
    xournalpp              # tablet notetaking software

    # B.5.5.9. Internet - Instant messaging clients (Other IM clients)
    telegram-desktop-gtk # # Telegram client (patched to use GTK3 over QT filepicker, see overlays)
    whatsapp-for-linux #   # unofficial client
    webcord #              # Alternative Discord client
    teams-for-linux
    zoom

    # F.3. Utilities - Development
    bruno #                # REST API client

    # F.6.21. Utilities - Compatibility layers
    bottles

    # G.1.6.2. Other - Task management (Graphical)
    ticktick

    # UNCATEGORISED
    linux-wifi-hotspot
    mindustry
  ];
}

