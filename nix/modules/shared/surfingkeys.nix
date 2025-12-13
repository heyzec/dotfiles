{
  lib,
  pkgs,
  userSettings,
  ...
}: {
  options = {
    heyzec.surfingkeys = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable surfingkeys configuration";
      };
      port = lib.mkOption {
        type = lib.types.int;
        default = 8123;
        description = "Port for the surfingkeys local server";
      };
      command = lib.mkOption {
        type = lib.types.str;
      };
      root = lib.mkOption {
        type = lib.types.str;
      };
    };
  };
  config = let
    root = "${userSettings.flakeDir}/browsers/surfingkeys";
    command = "${pkgs.nodejs}/bin/node ${root}/esbuild.js";
  in {
    heyzec.surfingkeys.root = root;
    heyzec.surfingkeys.command = command;
  };
}
