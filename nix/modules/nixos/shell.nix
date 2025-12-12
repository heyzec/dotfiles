{config, ...}: let
  cfg = config.heyzec.shell;
in {
  imports = [
    ../shared/shell.nix
  ];

  environment.systemPackages = cfg.packages;
}
