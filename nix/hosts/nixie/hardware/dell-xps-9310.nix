{inputs, ...}: {
  imports = [
    # - Blacklist psmouse kernel module
    # - Enable fwupd to update firmware via `fwupdmgr`
    # - Enable fstrim
    # - Enable updating of microcode for intel CPU
    inputs.nixos-hardware.nixosModules.dell-xps-13-9310
  ];
}
