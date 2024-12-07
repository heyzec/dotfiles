{pkgs, ...}: {
  services.ddclient = {
    enable = true;

    # The following block of code mirrors the traditional /etc/ddclient/ddclient.conf
    # For guide on using ddclient with DeSEC, see
    # https://desec.readthedocs.io/en/latest/dyndns/configure.html#manual-configuration-other-systems
    protocol = "dyndns2";
    ssl = true;
    server = "update.dedyn.io";
    username = "heyzec.dedyn.io";
    passwordFile = let
      passwordFile = pkgs.writeText "token.txt" ''
        ${(import ./ddns.crypt.nix).token}
      '';
    in "${passwordFile}";
    domains = ["heyzec.dedyn.io"];

    # Fix for NixOS ddclient module
    usev4 = "cmd, cmd='${pkgs.curl}/bin/curl https://checkipv4.dedyn.io/'";
  };
}
