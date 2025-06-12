{ userSettings, ... }: let
  inherit (userSettings) username homeDir;
in {
  services.syncthing = {
    enable = true;
    user = username;
    group = "users";
    dataDir = homeDir;
    configDir = "${homeDir}/.config/syncthing";
    settings = {
      overrideDevices = true;
      overrideFolders = true;
      devices = {
        "S20FE" = { id = "CMS62ZT-RSXEEHA-XM7YQ64-QC3425Q-DA3KGBS-W6OAZNN-SV2PD6U-NWBP7AX"; };
      };
      folders = {
        "Obsidian" = {
          id = "vault";
          path = "${homeDir}/Documents/Vault";
          devices = [ "S20FE" ];
        };
      };
    };
  };
}
