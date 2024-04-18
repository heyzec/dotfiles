{ pkgs, userSettings, ... }:
let
  username = userSettings.username;
  in
{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql;

    ensureDatabases = [
      username
    ];
    ensureUsers = [
      {
        name = username;
        ensureDBOwnership = true;
      }
    ];

    # Add additional rules here, by default all local IPv4, IPv6 and unix socket connections allowed
    # authentication = ''
    # '';
    enableTCPIP = false;
  };
}

