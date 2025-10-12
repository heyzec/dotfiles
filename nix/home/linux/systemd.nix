{ pkgs, ... }:
{
  # TODO: Remove, this is deprecated upstream since 2014
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

