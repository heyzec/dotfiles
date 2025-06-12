{inputs, ...}:
if inputs.private.hasPrivate
then let
  endpoint = inputs.private.devpad.attributes.btrbk.endpoint;
  backups_retention_policy = "7d 4w 12m";
  snapshots_retention_policy = "7d 4w 3m";
in {
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
          snapshot_preserve = snapshots_retention_policy;
          snapshot_dir = "@snapshots";

          target_preserve_min = "latest";
          target_preserve = backups_retention_policy;
          target = "ssh://${endpoint}/media/backups/btrbk/data";
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
          snapshot_preserve = snapshots_retention_policy;
          snapshot_dir = "@snapshots";

          target_preserve_min = "latest";
          target_preserve = backups_retention_policy;
          target = "ssh://${endpoint}/media/backups/btrbk/home";
        };
      };
    };
  };
}
else {}
