{
  lib,
  config,
  ...
}: let
  cfg = config.heyzec.neovim;
in {
  imports = [
    ../shared/neovim.nix
  ];

  environment.systemPackages = [
    cfg.package
  ];
  environment.variables.EDITOR = lib.mkIf cfg.defaultEditor "nvim";
}
