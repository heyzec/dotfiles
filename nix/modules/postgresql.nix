{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.heyzec.postgresql;
in {
  options = {
    heyzec.postgresql = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable postgresql server with a default database";
      };
      autoStart = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Start postgresql server on boot";
      };
      username = lib.mkOption {
        type = lib.types.str;
        description = "Username of main user to create a database for";
      };
    };
  };

  config = {
    services.postgresql =
      {
        enable = cfg.enable;
        package = pkgs.postgresql;
      }
      // lib.attrsets.optionalAttrs true {
        ensureDatabases = [
          cfg.username
        ];
        ensureUsers = [
          {
            name = cfg.username;
            ensureDBOwnership = true;
          }
        ];
      };
    systemd.services.postgresql.wantedBy =
      if cfg.autoStart
      # This empty list will be merged with default target defined by postgres module
      then []
      else lib.mkForce [];
  };
}
