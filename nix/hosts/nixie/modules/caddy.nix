{
  services.caddy.enable = true;
  services.caddy.logFormat = ''
    level DEBUG
  '';
  services.caddy.extraConfig = ''
    heyzec.dedyn.io {
      reverse_proxy * localhost:8123
    }
    source-academy.github.io, sa-modules.heyzec.dedyn.io {
      tls internal
      header {
        Access-Control-Allow-Origin *
      }

      root * /media/shared/sa-modules
      file_server
    }
  '';
}
