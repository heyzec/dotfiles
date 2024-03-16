# Refer to README.md

{
  fileSystems."/" = {
    device = "/dev/disk/by-partlabel/NixOS";
    fsType = "btrfs";
    options = [ "subvol=@root" ];
  };

  fileSystems."/home/heyzec" = {
    device = "/dev/disk/by-partlabel/NixOS";
    fsType = "btrfs";
    options = [ "subvol=@home" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/EFI";
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
    device = "/dev/disk/by-partlabel/NixOS";
    fsType = "btrfs";
    options = [ "subvolid=5" "nofail" ];
  };

  fileSystems."/mnt/D" = {
    device = "/dev/disk/by-partlabel/Data";
    fsType = "btrfs";
    options = [ "subvolid=5" "compress=zstd" "nofail" ];
  };

  fileSystems."/media/D" = {
    depends = [ "/mnt/D" ];
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
    { device = "/dev/disk/by-partlabel/Swap"; }
  ];
}
