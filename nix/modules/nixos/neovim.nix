{
  lib,
  config,
  ...
}: let
  cfg = config.heyzec.neovim;
in {
  imports = [
    ../neovim.nix
  ];
  environment.systemPackages = [
    cfg.package
  ];
  environment.variables.EDITOR = lib.mkIf cfg.defaultEditor "nvim";
}
