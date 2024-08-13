{ lib, pkgs, config, ... }:
let
  cfg = config.heyzec.postgresql;
in
{
  options = {
    heyzec.postgresql = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable postgresql server with a default database";
      };
      username = lib.mkOption {
        type = lib.types.string;
        description = "Username of main user to create a database for";
      };
    };
  };

  config = {
    services.postgresql = {
      enable = cfg.enable;
      package = pkgs.postgresql;
    } // lib.attrsets.optionalAttrs true {
      ensureDatabases = [
        cfg.username
      ];
      ensureUsers = [{
        name = cfg.username;
        ensureDBOwnership = true;
      }];
    };
  };
}
