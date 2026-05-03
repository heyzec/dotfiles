{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/05207b0f-bc89-4d13-989d-007d524f547a";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D50F-3A2F";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  fileSystems."/media/backups" = {
    device = "/dev/disk/by-uuid/ee69dacf-b915-40cb-a20e-bb13ac13e5f7";
    fsType = "btrfs";
    options = ["nofail"];
  };

  fileSystems."/media/shared" = {
    device = "/dev/disk/by-uuid/80656e65-b3bf-4423-b1a2-59a5199bd6e2";
    fsType = "btrfs";
    options = ["nofail"];
  };

  swapDevices = [];
}
