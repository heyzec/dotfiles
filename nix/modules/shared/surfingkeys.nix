{
  lib,
  config,
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
    };
  };
  config = let
    cfg = config.heyzec.surfingkeys;
    root = "${userSettings.flakeDir}/browsers/surfingkeys";
    command = "${pkgs.esbuild}/bin/esbuild ${root}/src/surfingkeys.ts --bundle --outfile=${root}/dist/surfingkeys.js --serve=127.0.0.1:${toString cfg.port} --watch=forever";
  in {
    heyzec.surfingkeys.command = command;
  };
}
