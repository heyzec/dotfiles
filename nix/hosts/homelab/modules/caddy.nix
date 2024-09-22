{
  services.caddy = {
    enable = true;

    # Uncomment this block for debug mode. Note that line "debug" will not work in NixOS unlike in Caddyfile
    # logFormat = ''
    #   level DEBUG
    # '';

    # TODO: Wildcard subdomain requires DNS challenge and setting up to DeSEC
    # virtualHosts."*.app.heyzec.dedyn.io".extraConfig = ''
    #   @sa host sa-vscode-frontend.app.heyzec.dedyn.io
    #
    #   handle @sa {
    #       header {
    #         Access-Control-Allow-Origin *
    #       }
    #       try_files /var/www/html /index.html
    #   }
    #
    #   handle {
    #       abort
    #   }
    # '';

    virtualHosts."sa-vscode-frontend.heyzec.dedyn.io".extraConfig = ''
      header {
        Access-Control-Allow-Origin *
      }
      file_server
      root * /var/www/html
      try_files {path} /index.html
    '';
  };
  networking.firewall.allowedTCPPorts = [80 443];

  services.fail2ban.enable = true;
}
