################################################################################
##### Networking Settings
################################################################################
{ systemSettings, ... }:
{
  networking = {
    hostName = systemSettings.hostname;
    networkmanager.enable = true;

    firewall = {
      enable = false;
      allowedTCPPorts = [
        80
      ];
    };
  };
}
