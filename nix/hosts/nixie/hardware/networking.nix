################################################################################
##### Networking Settings
################################################################################
{ systemSettings, ... }:
{
  networking = {
    hostName = systemSettings.hostname;
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [
        80
      ];
    };
  };
}
