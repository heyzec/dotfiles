{config, ...}: let
  cfg = config.heyzec.shell;
in {
  imports = [
    ../shared/shell.nix
  ];

  home.packages = cfg.packages;
}
