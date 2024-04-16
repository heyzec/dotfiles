{ pkgs, ... }:
{
  # These 4 lines are generated from hardware scan
  boot.initrd.availableKernelModules = [ "xhci_pci" "usbhid" ]; # no "uas"
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];


  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # The chunks are from hugolgst/nixos-raspberry-pi-cluster, not sure if absolutely necessary
  boot.kernelPackages = pkgs.linuxPackages_rpi4;
  # boot.loader.raspberryPi = {
  #   enable = true;
  #   version = 4;
  # };
}

