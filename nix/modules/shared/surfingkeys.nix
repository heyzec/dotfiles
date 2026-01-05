{
  lib,
  pkgs,
  self,
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
        description = "Read-only option for OS-specific submodule to use";
      };
      cwd = lib.mkOption {
        type = lib.types.str;
        description = "Read-only option for OS-specific submodule to use";
      };
    };
  };
  config = let
    server = pkgs.callPackage (self + "/browsers/surfingkeys/package.nix") {};
  in {
    heyzec.surfingkeys.command = "${server}/bin/serve";
    heyzec.surfingkeys.cwd = "${userSettings.flakeDir}/browsers/surfingkeys";
  };
}
