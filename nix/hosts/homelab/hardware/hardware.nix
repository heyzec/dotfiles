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

  hardware.firmware = [pkgs.linux-firmware];

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
