# Refer to README.md
{
  config,
  userSettings,
  ...
}: {
  ################################################################################
  ##### System mount points
  ################################################################################
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-partlabel/NixOS";
      fsType = "btrfs";
      options = ["subvol=@root"];
    };
    "/boot" = {
      device = "/dev/disk/by-partlabel/EFI";
      fsType = "vfat";
    };
    "/efi" = {
      device = "/boot";
      fsType = "none";
      options = ["bind"];
    };

    ################################################################################
    ##### User data mount points: Read-only (for backups)
    ################################################################################
    "/mnt/root" = {
      device = "/dev/disk/by-partlabel/NixOS";
      fsType = "btrfs";
      # options = [ "subvolid=5" "ro" "nofail" ];
      options = ["subvolid=5" "nofail"];
    };
    "/mnt/D" = {
      device = "/dev/disk/by-partlabel/Data";
      fsType = "btrfs";
      # options = [ "subvolid=5" "ro" "compress=zstd" "nofail" ];
      options = ["subvolid=5" "compress=zstd" "nofail"];
    };

    ################################################################################
    ##### User data mount points: Read-write
    ################################################################################
    "home" = {
      device = "/dev/disk/by-partlabel/NixOS";
      mountPoint = "/home/${userSettings.username}";
      fsType = "btrfs";
      options = ["subvol=@home"];
    };
    "documents" = {
      device = "${config.fileSystems."/mnt/D".mountPoint}/@data/Documents";
      mountPoint = "${config.fileSystems."home".mountPoint}/Documents";
      options = ["bind" "nofail"];
    };
    # "documents-remount" = {
    #   depends = [ "documents" ];
    #   device = "${config.fileSystems."home".mountPoint}/Documents";
    #   mountPoint = "${config.fileSystems."home".mountPoint}/Documents";
    #   options = [ "bind" "remount" "rw" "nofail" ];
    # };
    "D" = {
      depends = ["/mnt/D"];
      device = "/mnt/D/@data";
      mountPoint = "/media/D";
      fsType = "none";
      options = ["bind" "nofail"];
    };
    # "documents-readonly" = {
    #   device = config.fileSystems."documents".mountPoint;
    #   mountPoint = "${config.fileSystems."D".mountPoint}/Documents";
    #   options = [ "bind" "ro" "nofail" ];
    # };

    ################################################################################
    ##### Misc
    ################################################################################
    "/var/lib/docker/btrfs" = {
      device = "/@/var/lib/docker/btrfs";
      fsType = "none";
      options = ["bind"];
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-partlabel/Swap";}
  ];
}
