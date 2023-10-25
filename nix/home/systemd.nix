{ pkgs, ... }:
{
  systemd.user.services = {
    battery_status = {
      Unit = {
        Description = "low battery notification service";
      };
      Service = {
        Type = "oneshot";
        ExecStart = toString (
          pkgs.writeShellScript "battery-status-script" ''
            set -eou pipefail
            ${pkgs.bash}/bin/bash -c notify-send hi hi;
          ''
        );
      };
      Install.WantedBy = [ "default.target" ];
    };
  };

  systemd.user.timers = {
    battery_status = {
      Unit.Description = "timer for battery_status service";
      Timer = {
        Unit = "battery_status";
    OnBootSec = "1m";
        OnUnitActiveSec = "1m";
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
  systemd.user.services."polkit-agent" = {
    Unit = {
      Description = "polkit-gnome-authentication-agent-1";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}

