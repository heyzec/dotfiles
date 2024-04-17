{ lib, pkgs, ... }:
{
  systemd.user.services = {
    "AutoArchiver" = {
      Unit.Description = "Automatic archiving of folders";
      Service = {
        Type = "oneshot";
        ExecStart = toString (
          # The script will be executed in an empty PATH, so we need to populate it
          pkgs.writeShellScript "battery-status-script" ''
            PATH=$PATH:${lib.makeBinPath [ pkgs.bash pkgs.busybox ]}
            /home/heyzec/dotfiles/scripts/AutoArchiver.sh /home/heyzec/Downloads
            /home/heyzec/dotfiles/scripts/AutoArchiver.sh /home/heyzec/Pictures/Screenshots
         ''
        );
      };
      Install.WantedBy = [ "default.target" ];
    };
  };

  systemd.user.timers = {
    "AutoArchiver" = {
      Unit.Description = "Automatic archiving of folders";
      Timer = {
        Unit = "AutoArchiver.service";
        OnCalendar = "*-*-* 21:58:00";
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
