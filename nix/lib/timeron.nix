{ lib, pkgs, ... }:
{ name
, description
, schedule
, addToPath
, script
}:
{
  systemd.user.services = {
    "${name}" = {
      Unit.Description = description;
      Service = {
        Type = "oneshot";
        ExecStart = toString (
          # The script will be executed in an empty PATH, so we need to populate it
          pkgs.writeShellScript "${name}" (''
            PATH=$PATH:${lib.makeBinPath addToPath}
          '' + script)
        );
      };
      Install.WantedBy = [ "default.target" ];
    };
  };

  systemd.user.timers = {
    "${name}" = {
      Unit.Description = description;
      Timer = {
        Unit = "${name}.service";
        OnCalendar = schedule;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
