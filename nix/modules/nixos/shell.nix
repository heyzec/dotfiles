{config, ...}: let
  cfg = config.heyzec.shell;
in {
  imports = [
    ../shell.nix
  ];

  environment.systemPackages = cfg.packages;
}
