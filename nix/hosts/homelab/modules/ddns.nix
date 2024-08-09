{ pkgs, ... }:
let
  name = "ddns";
  description = "Update DDNS entry for heyzec.mooo.com";
  ddns_updater = /* bash */ ''

    # save stdout and stderr separately
    # https://stackoverflow.com/a/33166477
    rm -f stdout stderr || true
    mkfifo stdout stderr
    # HTTP HACK!!
    ${pkgs.wget}/bin/wget -O - http://freedns.afraid.org/dynamic/update.php?${(import ./ddns.crypt.nix).api-key} >stdout 2>stderr &
    exec {fdout}<stdout {fderr}<stderr
    rm stdout stderr
    stdout=$(cat <&$fdout)
    stderr=$(cat <&$fderr)

    echo $stdout

    if $(echo $stdout | grep -q 'ERROR: Address .* has not changed.'); then
      exit 0
    fi

    echo $stderr
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
