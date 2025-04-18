{
  pkgs,
  config,
  userSettings,
  ...
}: let
  homeDir = config.users.users.${userSettings.username}.home;
in {
  services.locate = {
    enable = true;
    package = pkgs.plocate;
    localuser = null; # to squelch warning: plocate does not support non-root updatedb
    pruneNames = [
      ".bzr"
      ".cache"
      ".git"
      ".hg"
      ".svn" # defaults
      "node_modules"
    ];
    prunePaths = [
      "/nix/store"
      "/mnt"
      "/media/D"
      "${homeDir}/.snapshots"
      "${homeDir}/.local/share/Trash"
    ];
  };
}
