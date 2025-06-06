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
