{config, ...}: let
  cfg = config.heyzec.neovim;
in {
  imports = [
    ../shared/neovim.nix
  ];

  home.packages = [cfg.package];
}
