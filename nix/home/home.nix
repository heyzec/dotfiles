# See https://rycee.gitlab.io/home-manager/options.html
{ lib, pkgs, userSettings, ... }:
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

  home.activation."dotsman-install" = lib.hm.dag.entryAfter ["writeBoundary"] ''
    PATH="${pkgs.gawk}/bin:${pkgs.git}/bin:$PATH"
    # Using symlinks in when the dotfiles folder is mounted VM gives too many levels error
    ${userSettings.dotfilesDir}/scripts/dotsman/dotsman.sh install all --no-dry-run
  '';

  heyzec.shell.enable = lib.strings.hasSuffix "darwin" pkgs.system;
}

# TODO: fix swhkd not starting, we need it for vm
# pylance (vscode’s extension for Python) vs pyright (standard LSP for Python),
