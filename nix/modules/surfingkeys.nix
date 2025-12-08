{
  lib,
  config,
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
    isNixos = true;
  in
    # if isNixos
    # then {
    #   systemd.user.services.surfingkeys = {
    #     Service = {
    #     };
    #   };
    # }
    # else {
    # };
    # lib.mkMerge [
    #   (lib.mkIf isNixos {
    #     environment.systemPackages = [pkgs.htop];
    #   })
    #   (lib.mkIf (!isNixos) {
    #     home = {
    #       packages = [pkgs.htop];
    #     };
    #   })
    # ];
    lib.mkMerge [
      (lib.mkIf false {
        home = {};
      })
    ];
}
