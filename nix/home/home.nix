# See https://rycee.gitlab.io/home-manager/options.html
{
  lib,
  pkgs,
  userSettings,
  ...
}: {
  # We're using the "Standalone installation" option, let home-manager install itself
  programs.home-manager.enable = true;

  home = {
    username = userSettings.username;
    homeDirectory = userSettings.homeDir;
  };

  # Install non-Nix dotfiles on every activation
  home.activation."dotsman-install" = lib.hm.dag.entryAfter ["writeBoundary"] ''
    PATH="${pkgs.gawk}/bin:${pkgs.git}/bin:$PATH"
    # Using symlinks in when the dotfiles folder is mounted VM gives too many levels error
    ${userSettings.dotfilesDir}/scripts/dotsman/dotsman.sh install all --no-dry-run
  '';

  # Enable shell for Darwin systems (for Linux systems is enabled via a NixOS module)
  heyzec.shell.enable = lib.strings.hasSuffix "darwin" pkgs.system;

  home.stateVersion = "23.05";
}
