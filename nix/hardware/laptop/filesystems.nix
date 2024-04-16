# Refer to README.md
{ userSettings, ... }:
{
  fileSystems."/" = {
    device = "/dev/disk/by-partlabel/NixOS";
    fsType = "btrfs";
    options = [ "subvol=@root" ];
  };

  fileSystems."/home/${userSettings.username}" = {
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

  swapDevices = [
    { device = "/dev/disk/by-partlabel/Swap"; }
  ];
}
