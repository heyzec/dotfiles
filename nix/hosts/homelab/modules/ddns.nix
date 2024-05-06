{ pkgs, ... }:
let
  name = "ddns";
  description = "Update DDNS entry for heyzec.mooo.com";
  ddns_updater = /* bash */ ''
      msg=$(${pkgs.wget}/bin/wget -q -O - https://freedns.afraid.org/dynamic/update.php?${(import ./ddns.crypt.nix).api-key})
      echo $msg

      if $(echo $msg | grep -q 'ERROR: Address .* has not changed.'); then
        exit 0
      fi

      exit 1
    '';
in
{
  # Update DDNS entry for heyzec.mooo.com
  systemd.services = {
    ${name} = {
      inherit description;
      onFailure = [ "notify-failure@%n.service" ];
      serviceConfig = {
        Type = "oneshot";
      };
      script = ddns_updater;
    };
  };

  systemd.timers = {
    ${name} = {
      inherit description;
      timerConfig = {
        # Every 15 minutes
        OnCalendar = "*:0/15";
        RandomizedDelaySec = 30;
        Unit = "${name}.service";
      };
      wantedBy = [ "timers.target" ];
    };
  };
}
