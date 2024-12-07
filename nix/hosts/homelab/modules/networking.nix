{
  networking = {
    hostName = "raspberrypi";
    useDHCP = false;
    interfaces.eth0.useDHCP = true;
    # interfaces.eth0.macAddress = "b8:00:00:00:00:00";
    interfaces.wlan0.useDHCP = true;
    firewall.enable = true;
  };

  services.fail2ban.enable = true;
}
