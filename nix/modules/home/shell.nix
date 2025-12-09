{
  config,
  ...
}: let
  cfg = config.heyzec.neovim;
in {
  imports = [
    ../shared/shell.nix
  ];
  config = {
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;

    home.packages = cfg.packages;
  };
}
