{
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
      fsType = "ext4";
    };

  fileSystems."/boot/raspberrypi" =
    { device = "/dev/disk/by-label/FIRMWARE";
      options = [ "nofail" ]; # just in case for now
    };

  fileSystems."/media/backups" =
    { device = "/dev/disk/by-uuid/ee69dacf-b915-40cb-a20e-bb13ac13e5f7";
      fsType = "btrfs";
      options = [ "nofail" ];
    };

  fileSystems."/media/shared" =
    { device = "/dev/disk/by-uuid/80656e65-b3bf-4423-b1a2-59a5199bd6e2";
      fsType = "btrfs";
      options = [ "nofail" ];
    };

  swapDevices = [ ];
}

