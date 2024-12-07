{
  pkgs,
  lib,
  ...
}: {
  security.polkit.enable = true;

  nix.settings.trusted-users = ["pi"]; # https://github.com/NixOS/nix/issues/2127#issuecomment-1465191608

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  environment.systemPackages = with pkgs; [
    bluez # bluetooth related commands (e.g. bluetoothctl)
  ];

  hardware.bluetooth.enable = true;
  hardware.raspberry-pi."4".bluetooth.enable = true;
}
