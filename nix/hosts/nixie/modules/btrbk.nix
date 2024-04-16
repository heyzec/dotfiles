{
  # Note: To generate config at default location, name instance to be "btrbk" instead
  services.btrbk.instances = {
    "data" = {
      onCalendar = "*-*-* 22:00:00";
      settings = {
        ssh_identity = "/etc/btrbk/btrbk";
        ssh_user = "btrbk";
        volume."/mnt/D" = {
          subvolume = "@data";

          snapshot_preserve_min = "latest";
          snapshot_preserve = "7d 4w 1m";
          snapshot_dir = "@snapshots";

          target_preserve_min = "latest";
          target_preserve = "7d 4w 1m";
          target = "ssh://heyzec.mooo.com:40478/media/backups/btrbk/data";
        };
      };
    };
    "home" = {
      onCalendar = "*-*-* 22:00:00";
      settings = {
        ssh_identity = "/etc/btrbk/btrbk";
        ssh_user = "btrbk";
        volume."/mnt/root" = {
          subvolume = "@home";

          snapshot_preserve_min = "latest";
          snapshot_preserve = "7d 4w 1m";
          snapshot_dir = "/mnt/root/@home/.snapshots/";

          target_preserve_min = "latest";
          target_preserve = "7d 4w 1m";
          target = "ssh://heyzec.mooo.com:40478/media/backups/btrbk/home";
        };
      };
    };
  };
}

