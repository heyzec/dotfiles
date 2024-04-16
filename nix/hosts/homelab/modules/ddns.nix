{ pkgs, ... }:
{
  # Update DDNS entry for heyzec.mooo.com
  systemd.services."dns" = {
    path = with pkgs; [
      iproute2
      gnugrep
      wget
    ];
    script = ''
      /home/pi/router-scripts/check_router.sh && /home/pi/router-scripts/ddns_updater.sh
    '';
    serviceConfig = {
      WorkingDirectory = "/home/pi";
      Type = "oneshot";
    };
  };
  systemd.timers."dns" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "";
      RandomizedDelaySec = 30;
      Unit = "dns.service";
    };
  };
# 1,31 * * * * /home/pi/router-scripts/check_router.sh && /home/pi/router-scripts/ddns_updater.sh
}

