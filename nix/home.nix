{ config, lib, pkgs, ... }:

with import <nixpkgs> {};
with builtins;
with lib;
with import <home-manager/modules/lib/dag.nix> { inherit lib; };

let
in
{
  home.packages = [
  ];


  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = ["thunar.desktop"];
      "text/x-uri" = ["firefox.desktop"];
      "x-scheme-handler/http" = ["firefox.desktop"];
      "x-scheme-handler/https" = ["firefox.desktop"];
      "image/png" = ["qimgv.desktop"];
    };
  };


  programs.home-manager.enable = true;
  home.stateVersion = "23.05";
  home.username = "heyzec";
  home.homeDirectory = "/home/heyzec";
  dconf.settings = {
      "com/raggesilver/BlackBox" = { 
        "show-headerbar" = false;
        "opacity" = lib.hm.gvariant.mkUint32 50;
        "theme-dark" = "Modified Tango";
        "use-sixel" = true;
        "font" = "Monospace 11";
      };


  };

  xdg.configFile."hyprland" = {
    source = /mnt/arch/home/heyzec/.config/hypr/hyprland.conf;
    target = "hypr/hyprland.conf";
  };
  xdg.configFile."waybar" = {
    source = /home/heyzec/dotfiles/desktop/waybar;
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
    source = /home/heyzec/dotfiles/git/.gitconfig;
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

  # Doesn't seem to work
  gtk.enable = true;
  gtk.gtk3.bookmarks = [
    "file:///home/heyzec/Documents"
    "file:///home/heyzec/Downloads"
    "file:///home/heyzec/Music"
    "file:///home/heyzec/Pictures"
    "file:///home/heyzec/Videos"
    "file:///home/heyzec/Documents/NUS"
    "file:///home/heyzec/Documents/NUS/CVWO"
  ];


  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP="Hyprland";
    XDG_SESSION_TYPE="wayland";
    TERMINAL = "blackbox";
  };

  # programs.firefox.enable = true;
  # programs.firefox.profiles."Dual Boot Profile" = {

  #   id = 6;
  #   # isRelative = false;
  #   # path = "/media/D/Common AppData/Firefox/profile4";
  #   path = "../../../../media/D/Common AppData/Firefox/profile4";
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

  # systemd.user.services.dropbox = {
  #   Unit = {
  #     Description = "Dropbox";
  #     After = [ "graphical-session-pre.target" ];
  #     PartOf = [ "graphical-session.target" ];
  #   };

  #   Service = {
  #     Restart = "on-failure";
  #     RestartSec = 1;
  #     ExecStart = "${pkgs.dropbox}/bin/dropbox";
  #     Environment = "QT_PLUGIN_PATH=/run/current-system/sw/${pkgs.qt5.qtbase.qtPluginPrefix}";
  #    };

  #   Install = {
  #       WantedBy = [ "graphical-session.target" ];
  #   };

  # };

  # home.file = { 

  # ".config/inkscape" = {
  #   source = ./inkscape;
  #   recursive = true;
  # };


  # ".tmux.conf" = {
  #  text = ''
  #  set-option -g default-shell /run/current-system/sw/bin/fish
  #  set-window-option -g mode-keys vi
  #  set -g default-terminal "screen-256color"
  #  set -ga terminal-overrides ',screen-256color:Tc'
  #  '';
  # };

  # ".config/fish/config.fish" = {
  #   text = ''  
  #   set -x GPG_TTY (tty)
  #   gpg-connect-agent updatestartuptty /bye > /dev/null
  #   set -x SSH_AUTH_SOCK $XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh
  #   set -x EDITOR vim
  #   set -x TERM xterm-256color
  #   if status --is-interactive
  #      set -g fish_user_abbreviations
  #      abbr h 'home-manager switch'
  #      abbr r 'sudo nixos-rebuild switch'
  #      abbr gvim vim -g
  #      abbr mc 'env TERM=linux mc'
  #      abbr tmux 'tmux -2'
  #   end
  #   function __fish_command_not_found_handler --on-event fish_command_not_found
  #      command-not-found $argv[1]
  #   end
  #   '';
  # };


  # ".local/share/applications/defaults.list" = {
  #    text = ''
  #    [Default Applications]
  #    application/pdf=zathura.desktop
  #    '';
  # };

  # ".config/astroid/config" = {
  #   text = toJSON (import ./mail/astroid.nix {
  #     inherit pkgs;
  #   });
  # };

  # ".ssh/id_rsa.pub".source = ./id_rsa.pub;


  # home.activation.copyIdeaKey = dagEntryAfter ["writeBoundary"] ''
  #     install -D -m600 ${./private/idea.key} $HOME/.IntelliJIdea2018.1/config/idea.key
  # '';

  # home.activation.copySSHKey = dagEntryAfter ["writeBoundary"] ''
  #     install -D -m600 ${./private/id_rsa} $HOME/.ssh/id_rsa
  # '';

  # home.activation.authorizedKeys = dagEntryAfter ["writeBoundary"] ''
  #     install -D -m600 ${./id_rsa.pub} $HOME/.ssh/authorized_keys
  # '';

  # home.activation.mailPasswords = dagEntryAfter ["writeBoundary"] ''
  #    mkdir -p $HOME/.mail/gmail
  #    install -m600 ${./mail/pass-yrashk} $HOME/.mail/pass-yrashk
  #    install -m600 ${./mail/pass-gmail} $HOME/.mail/pass-gmail
  # '';

}
