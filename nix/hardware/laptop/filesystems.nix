{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/40cd3c9f-96a0-4132-94af-d4eac638b744";
    fsType = "btrfs";
    options = [ "subvol=@root" ];
  };

  fileSystems."/home/heyzec" = {
    device = "/dev/disk/by-uuid/40cd3c9f-96a0-4132-94af-d4eac638b744";
    fsType = "btrfs";
    options = [ "subvol=@home" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9BDA-8A89";
    fsType = "vfat";
  };

  fileSystems."/efi" = {
    device = "/boot";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/var/lib/docker/btrfs" = {
    device = "/@/var/lib/docker/btrfs";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/mnt/root" = {
    device = "/dev/disk/by-uuid/40cd3c9f-96a0-4132-94af-d4eac638b744";
    fsType = "btrfs";
    options = [ "subvolid=5" "nofail" ];
  };

  fileSystems."/mnt/D" = {
    device = "/dev/disk/by-label/Data";
    fsType = "btrfs";
    options = [ "subvolid=5" "compress=zstd" "nofail" ];
  };

  fileSystems."/media/D" = {
    depends = [ "/mnt/D" ];
    label = "Data D";
    device = "/mnt/D/@data";
    fsType = "none";
    options = [ "bind" "nofail" ];
  };

#   fileSystems."/home/heyzec/Private" = {
#     device = "/dev/mapper/private";
#     fsType = "auto";
#     options = [ "noauto" "x-systemd.automount" "x-systemd.mount-timeout=5" "nofail" ];
#   };

  swapDevices = [
    { device = "/dev/disk/by-uuid/04668d02-fa34-4c6d-9de3-092cffd62de4"; }
  ];
}
