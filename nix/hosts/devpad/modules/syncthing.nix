{userSettings, ...}: let
  inherit (userSettings) username homeDir;
in {
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = username;
    group = "users";
    dataDir = homeDir;
    configDir = "${homeDir}/.config/syncthing";
    settings = {
      overrideDevices = true;
      overrideFolders = true;
    };
  };
}
