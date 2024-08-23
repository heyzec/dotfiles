{ pkgs, ... }: {
  # https://github.com/NixOS/nixpkgs/issues/216361
  # Packages here can break if nixpkgs-unstable goes out of sync with home manager master
  home.packages = with pkgs; [
    insomnia    # REST API client

    ##### Applications: Communication Utilities
    telegram-desktop-gtk  # Telegram client (patched to use GTK3 over QT filepicker, see overlays)
    webcord               # Alternative Discord client
    whatsapp-for-linux    # unofficial client
    # zoom              # Zoom client
    teams-for-linux
    slack



    pdfsam-basic           # PDF editing
    xournalpp        # tablet notetaking software
    joplin-desktop


    # [Specialised CTF Tools]
    thc-hydra        # online password-cracking tool
    john             # John the Ripper, an offline password-cracker

    tectonic


    dbeaver-bin

    waypaper

    ticktick
    linux-wifi-hotspot
    bottles
    mindustry
  ];
}

