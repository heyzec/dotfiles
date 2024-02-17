{
    services.btrbk = {
      # Note: To generate config at default location, name instance to be "btrbk" instead

      instances."data" = {
        onCalendar = "*-*-* 22:00:00";
        settings = {
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
      instances."home" = {
        onCalendar = "*-*-* 22:00:00";
        settings = {
        ssh_user = "btrbk";
          volume."/mnt/root" = {
            snapshot_preserve_min = "latest";
            snapshot_preserve = "7d 4w 1m";

            subvolume = "@home";
            snapshot_dir = "/mnt/root/@home/.snapshots/";
            target = "ssh://heyzec.mooo.com:40478/media/backups/btrbk/home";
          };
        };
      };
    };
}

