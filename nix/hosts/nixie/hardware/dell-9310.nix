{ ... }:
# Adapted from https://github.com/NixOS/nixos-hardware/blob/master/dell/xps/13-9310/default.nix
{
  # Includes the Wi-Fi and Bluetooth firmware for the QCA6390.
  hardware.enableRedistributableFirmware = true;

  # Touchpad goes over i2c.
  # Without this we get errors in dmesg on boot and hangs when shutting down.
  boot.blacklistedKernelModules = [ "psmouse" ];

  # Allows for updating firmware via `fwupdmgr`.
  services.fwupd.enable = true;

  services.fstrim.enable = true;

  hardware.cpu.intel.updateMicrocode = true;
}
