# See https://rycee.gitlab.io/home-manager/options.html
{ config, lib, pkgs, inputs, ... }:

with builtins;
with lib;



let
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
in
{

  imports = [
    # inputs.nix-colors.homeManagerModules.default
  ];

  home.file.colortest = {
    text = ''
      ${colorScheme.colors.base01}
      ${colorScheme.colors.base02}
      ${colorScheme.colors.base03}
      ${colorScheme.colors.base04}
      ${colorScheme.colors.base05}
      ${colorScheme.colors.base06}
      ${colorScheme.colors.base07}
      ${colorScheme.colors.base08}
      ${colorScheme.colors.base09}
      ${colorScheme.colors.base0A}
      ${colorScheme.colors.base0B}
      ${colorScheme.colors.base0C}
      ${colorScheme.colors.base0D}
      ${colorScheme.colors.base0E}
      ${colorScheme.colors.base0F}
    '';
    target = "colortest";
  };


  home.packages = with pkgs; [
    eza
    bat


    kitty
    blackbox-terminal

    reflex
    insomnia    # REST API client

    ##### Applications: Communication Utilities
    telegram-desktop # Telegram client
    webcord # Alternative Discord client
    whatsapp-for-linux # unofficial client
    # zoom             # Zoom client
    teams-for-linux



    pdfsam-basic           # PDF editing
    xournalpp        # tablet notetaking software
    stable.joplin-desktop


    # [Specialised CTF Tools]
    thc-hydra        # online password-cracking tool
    john             # John the Ripper, an offline password-cracker
    nmap             # port scanner
    # TODO: Fix privilege issues so that wireshark CLI is user but wireshark-cli is root
    # wireshark-qt     # network analyzer


    # texlive.combined.scheme-full
    tectonic


    dbeaver
    nix-output-monitor

    (openfortivpn.overrideAttrs(old: {
      src = builtins.fetchTarball "https://github.com/adrienverge/openfortivpn/archive/refs/tags/v1.20.4.tar.gz";
    }))

    flavours

    waypaper killall

    ticktick
  ];


  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain" = ["org.gnome.TextEditor.desktop"];
      "inode/directory" = ["thunar.desktop"];
      "text/x-uri" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "x-scheme-handler/mailto" = ["firefox.desktop"];
      "image/*" = ["qimgv.desktop"];
      "image/png" = ["qimgv.desktop"];
      "image/jpeg" = ["qimgv.desktop"];
      "video/*" = ["vlc.desktop"];
      "application/pdf" = ["atril.desktop"];
      "application/x-archive" = [ "gnome-file-roller.desktop" ];
    };
  };
  xdg.configFile."mimeapps.list".force = true;


  # We're using the "Standalone installation" option, let home-manager install itself
  programs.home-manager.enable = true;

  home.stateVersion = "23.05";
  home.username = "heyzec";
  home.homeDirectory = "/home/heyzec";

  # SYMLINKED CONFIGS {{{
  xdg.configFile."hyprland" = {
    source = config.lib.file.mkOutOfStoreSymlink /home/heyzec/dotfiles/desktop/hyprland/hyprland.conf;
    target = "hypr/hyprland.conf";
  };
  xdg.configFile."waybar" = {
    source = config.lib.file.mkOutOfStoreSymlink /home/heyzec/dotfiles/desktop/waybar;
    target = "waybar";
  };
  xdg.configFile."kanshi" = {
    source = /home/heyzec/dotfiles/desktop/kanshi/config;
    target = "kanshi/config";
  };
  xdg.configFile."starship" = {
    source = /home/heyzec/dotfiles/zsh/starship.toml;
    target = "starship.toml";
  };
  home.file."zsh" = {
    source = /home/heyzec/dotfiles/zsh/.zshenv;
    target = ".zshenv";
  };
  home.file."gitconfig" = {
    source = config.lib.file.mkOutOfStoreSymlink /home/heyzec/dotfiles/git/.gitconfig;
    target = ".gitconfig";
  };

  xdg.configFile."vscode-settings" = {
    source = config.lib.file.mkOutOfStoreSymlink /home/heyzec/dotfiles/vscode/keybindings.json;
    target = "Code/User/keybindings.json";
  };
  xdg.configFile."vscode-keybindings" = {
    source = config.lib.file.mkOutOfStoreSymlink /home/heyzec/dotfiles/vscode/settings.json;
    target = "Code/User/settings.json";
  };

  home.file.Documents = {
    source = config.lib.file.mkOutOfStoreSymlink /media/D/Documents;
    target = "Documents";
  };
  home.file.Downloads = {
    source = config.lib.file.mkOutOfStoreSymlink /media/D/Downloads;
    target = "Downloads";
  };
  home.file.Music = {
    source = config.lib.file.mkOutOfStoreSymlink /media/D/Music;
    target = "Music";
  };
  home.file.Pictures = {
    source = config.lib.file.mkOutOfStoreSymlink /media/D/Pictures;
    target = "Pictures";
  };
  home.file.Videos = {
    source = config.lib.file.mkOutOfStoreSymlink /media/D/Videos;
    target = "Videos";
  };
  # }}}

  # Doesn't seem to work
  gtk.enable = true;
  gtk.gtk3.bookmarks = [
    "file:///home/heyzec/Documents"
    "file:///home/heyzec/Downloads"
    "file:///home/heyzec/Music"
    "file:///home/heyzec/Pictures"
    "file:///home/heyzec/Videos"
    "file:///home/heyzec/Documents/NUS"
    "file:///home/heyzec/Documents/NUS/Current%20Mods/CS3103%20Computer%20Networks%20Practice CS3103"
    "file:///home/heyzec/Documents/NUS/Current%20Mods/CS3230%20Design%20and%20Analysis%20of%20Algorithms CS3230"
    "file:///home/heyzec/Documents/NUS/Current%20Mods/CS3235%20Computer%20Security CS3235"
    "file:///home/heyzec/Documents/NUS/Current%20Mods/MA2104%20Multivariable%20Calculus MA2104"
  ];


  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP="Hyprland";
    XDG_SESSION_TYPE="wayland";
    TERMINAL = "blackbox";
  };

  home.file."firefox-profile-workaround" = {
    source = config.lib.file.mkOutOfStoreSymlink "/media/D/Common AppData/Firefox/profile4";
    target = ".mozilla/firefox/DualBootProfile";
  };
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override {
      cfg = { enableTridactylNative = true; };
    };
    profiles."new" = {
      path = "DualBootProfile";
      userContent = ''
        .wsn-google-focused-link {
          border-left: 3px solid #2586fc !important;
          transform: translate(-3px, 0) !important;
          padding-left: 8px;
          margin-left: -11px;
        }
      '';
      # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      #   ublock-origin
      # ];
    };
  };


  # programs.firefox.profiles."New one" = {
  #   isDefault = true;
  # };

  #   id = 6;
  #   # isRelative = false;
  #   # path = "/media/D/Common AppData/Firefox/profile4";
  #   isDefault = true;
  # };


  # programs.command-not-found.enable = true;

  # services.udiskie = {
  #   enable = true;
  # };

  # services.gpg-agent = {
  #   enable = true;
  #   enableSshSupport = true;
  #   defaultCacheTtl = 1800;
  # };

  services.mako = {
    enable = true;
    defaultTimeout = 10000;
    backgroundColor = "#${colorScheme.colors.base01}";
    borderColor = "#${colorScheme.colors.base0E}";
    textColor = "#${colorScheme.colors.base04}";
    borderRadius = 5;
    borderSize = 2;
  };

  systemd.user.services = {
    battery_status = {
      Unit = {
        Description = "low battery notification service";
      };
      Service = {
        Type = "oneshot";
        ExecStart = toString (
          pkgs.writeShellScript "battery-status-script" ''
            set -eou pipefail
            ${pkgs.bash}/bin/bash -c notify-send hi hi;
          ''
        );
      };
      Install.WantedBy = [ "default.target" ];
    };
  };

  systemd.user.timers = {
    battery_status = {
      Unit.Description = "timer for battery_status service";
      Timer = {
        Unit = "battery_status";
    OnBootSec = "1m";
        OnUnitActiveSec = "1m";
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
  systemd.user.services."polkit-agent" = {
    Unit = {
      Description = "polkit-gnome-authentication-agent-1";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };



  # https://wiki.archlinux.org/title/GTK

  gtk.theme = {
    name = "Materia-light";
  };
  gtk.iconTheme = {
    # # https://github.com/vinceliuice/vimix-icon-theme
    # name = "Vimix-Black";

    name = "Vimix-Black";
    package = pkgs.vimix-gtk-themes;


  };
  # Cursors
  # gtk.cursorTheme = {
  #   # https://github.com/vinceliuice/vimix-icon-theme
  #   name = "capitaine-cursors";
  #   package = pkgs.capitaine-cursors;
  # };
  # # https://www.gnome-look.org/browse?cat=107&ord=latest

  qt.enable = true;
  qt.style.name = "adwaita";

  # APPLICATION SPECIFIC CONFIGS {{{
  dconf.settings = {
      "com/raggesilver/BlackBox" = { 
        "show-headerbar" = false;
        "opacity" = lib.hm.gvariant.mkUint32 50;
        "theme-dark" = "Modified Tango";
        "use-sixel" = true;
        "font" = "Monospace 11";
      };
  };

  xdg.configFile."joplin-plugin-tabs" = {
    source = builtins.fetchurl {
      url = "https://github.com/benji300/joplin-note-tabs/releases/download/v1.4.0/joplin.plugin.note.tabs.jpl";
      sha256 = "1mdw3p8g1sklyj1jicwgxlalvrg4zrrs2aizbrm7bym7lm8b8znv";
    };
    target = "joplin-desktop/plugins/joplin.plugin.note.tabs.jpl";
  };
  xdg.configFile."joplin-plugin-sidebars" = {
    source = builtins.fetchurl {
      url = "https://github.com/joplin/plugins/releases/download/plugins/org.joplinapp.plugins.ToggleSidebars@1.0.3.jpl";
      name = "org.joplinapp.plugins.ToggleSidebars.jpl";
      sha256 = "12clq50vplg8c3mnaybh861ap2bawlpazrzbnq10q5izswvl1x8g";
    };
    target = "joplin-desktop/plugins/org.joplinapp.plugins.ToggleSidebars.jpl";
  };
  # }}}



}
# vim: set ts=2 sts=2 sw=2:

