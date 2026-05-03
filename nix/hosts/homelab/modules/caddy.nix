{
  services.caddy = {
    enable = true;
    # Allow imperatively adding more virtual hosts from /etc/caddy/extra_config
    extraConfig = ''
      import extra_config
    '';
  };

  networking.firewall.allowedTCPPorts = [80 443];

  services.fail2ban.enable = true;
}
