# See https://rycee.gitlab.io/home-manager/options.html
{ lib, pkgs, config, userSettings, ... }:
{
  # We're using the "Standalone installation" option, let home-manager install itself
  programs.home-manager.enable = true;

  home.stateVersion = "23.05";
  home.username = userSettings.username;
  home.homeDirectory = userSettings.homeDir;

  # https://github.com/nix-community/home-manager/issues/1011
  # Does not work
  # home.sessionVariables = {
  #   XDG_CURRENT_DESKTOP = "Hyprland";
  #   XDG_SESSION_DESKTOP="Hyprland";
  #   XDG_SESSION_TYPE="wayland";
  #   TERMINAL = "foot";
  # };

  # Own implementation of a "backend" of home.sessionVariables
  # https://github.com/nix-community/home-manager/issues/2751
  # programs.zsh.enable = true;
  home.file.".profile".text = lib.strings.concatStringsSep "\n"
    (lib.attrsets.mapAttrsToList (name: value: "${name}=${value}")
      config.home.sessionVariables);

  # home.activation."dotsman-install" = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #   PATH="${pkgs.gawk}/bin:${pkgs.git}/bin:$PATH"
  #   # Using symlinks in when the dotfiles folder is mounted VM gives too many levels error
  #   ${userSettings.dotfilesDir}/scripts/dotsman/dotsman.sh install all --no-dry-run
  # '';

  heyzec.shell.enable = lib.strings.hasSuffix "darwin" pkgs.system;
  # services.kdeconnect.enable = true;
  home.packages = with pkgs; [
    telegram-desktop
    localsend
  ];

  imports = [
    ./lseg.nix
  ];
}

# TODO: fix swhkd not starting, we need it for vm
# pylance (vscode’s extension for Python) vs pyright (standard LSP for Python),
