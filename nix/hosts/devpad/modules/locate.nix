{
  options,
  config,
  userSettings,
  ...
}: let
  homeDir = config.users.users.${userSettings.username}.home;
in {
  services.locate = {
    enable = true;
    pruneNames =
      options.services.locate.pruneNames.default
      ++ [
        "node_modules"
        ".direnv"
      ];
    prunePaths =
      options.services.locate.prunePaths.default
      ++ [
        "/mnt"
        "/media/D"
        "/var/lib"
        "${homeDir}/.snapshots"
        "${homeDir}/.local/share/Trash"
      ];
  };
}
