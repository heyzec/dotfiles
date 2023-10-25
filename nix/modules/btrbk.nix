{
    services.btrbk = {
      # Name instance to be "btrbk" to generate config at default location.
      instances."btrbk" = {
        onCalendar = "*-*-* 22:00:00";
        settings = {
        # ssh_identity = "/home/heyzec/.ssh/id_ed25519";
        ssh_user = "btrbk";
          volume."/mnt/D" = {
            snapshot_preserve_min = "latest";
            snapshot_preserve = "7d 4w 1m";

            subvolume = "@data";
            snapshot_dir = "@snapshots";
            target = "ssh://heyzec.mooo.com:40478/media/backups/btrbk";
          };
        };
      };
    };
}

