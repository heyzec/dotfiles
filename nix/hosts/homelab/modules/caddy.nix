{
  services.caddy = {
    enable = true;
  };
  networking.firewall.allowedTCPPorts = [80 443];

  services.fail2ban.enable = true;
}
