{inputs, ...}: {
  imports = [
    # - Use extlinux boot loader instead of GRUB
    # - Use a variant of the Linux kernel (linux_rpi)
    # - And a lot of other settings, e.g. audio, bluetooth, gpio
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  hardware.raspberry-pi."4" = {
    apply-overlays-dtmerge.enable = true;
    fkms-3d.enable = true; # Enable GPU acceleration (a must for X!)
    bluetooth.enable = true;
  };
}
