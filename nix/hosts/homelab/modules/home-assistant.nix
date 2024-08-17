{ pkgs, ... }:
{
  services.home-assistant = {
    enable = true;
    extraComponents = [
      "xiaomi_ble"
    ];
    config = {
      default_config = {};
    };
  };
  networking.firewall.allowedTCPPorts = [ 8123 ];
  environment.systemPackages = with pkgs; [
    bluez               # bluetooth related commands (e.g. bluetoothctl)
  ];
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.raspberry-pi."4".bluetooth.enable = true;
}
