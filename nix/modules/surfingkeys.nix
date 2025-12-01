{
  lib,
  pkgs,
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
    };
  };
  config = let
    root = "/home/heyzec/dotfiles/browsers/surfingkeys";
    command = "${pkgs.esbuild}/bin/esbuild ${root}/surfingkeys.ts --bundle --outfile=${root}/dist/surfingkeys.js --serve --watch=forever";
  in
    if pkgs.stdenv.isLinux
    then {
      systemd.user.services.surfingkeys = {
        Service = {
          ExecStart = "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular";
        };
      };
    }
    else {
      launchd.daemons.surfingkeys = {
        inherit command;
        serviceConfig = {
          KeepAlive = true;
          RunAtLoad = true;
        };
      };
    };
}
