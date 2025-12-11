{config, ...}: let
  cfg = config.heyzec.shell;
in {
  imports = [
    ../shared/shell.nix
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  home.packages = cfg.packages;
}
