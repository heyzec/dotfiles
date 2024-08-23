{ pkgs, ... }:
{
  services.home-assistant = {
    enable = true;
    extraComponents = [
      "xiaomi_ble"
    ];

    # Your configuration.yaml as a Nix attribute set.
    config = {
      default_config = {};
      http = {
        base_url = "https://heyzec.dedyn.io";
        # Setup for reverse proxy to properly accept connections
        use_x_forwarded_for = true;
        trusted_proxies = [ "127.0.0.1" "::1" ];
      };
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
