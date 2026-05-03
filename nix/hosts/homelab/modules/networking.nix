{pkgs, ...}: {
  networking = {
    hostName = "homelab";
    firewall.enable = true;

    # Current router cannot set two DHCP reservations to same IP, hence this workaround
    interfaces = {
      # Use same MAC address for router to reserve same IP regardless of connection type
      eth0.macAddress = "02:00:00:00:00:02";
      wlan0.macAddress = "02:00:00:00:00:02";
    };
    networkmanager.dispatcherScripts = [
      # Ensure only one interface is up at a time (otherwise will have connection issues)
      {
        source = pkgs.writeText "toggle-wifi" ''
          INTERFACE=$1
          EVENT=$2
          if [ "$INTERFACE" = "eth0" ]; then
              if [ "$EVENT" = "up" ]; then
                  /run/current-system/sw/bin/nmcli radio wifi off
              elif [ "$EVENT" = "down" ]; then
                  /run/current-system/sw/bin/nmcli radio wifi on
              fi
          fi
        '';
      }
    ];
  };

  services.fail2ban.enable = true;
}
