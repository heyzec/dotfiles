{
  pkgs,
  lib,
  ...
}: {
  # Bluetooth
  hardware.bluetooth.enable = true;
  environment.systemPackages = with pkgs; [
    bluez # bluetooth related commands (e.g. bluetoothctl)
  ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
