{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    awscli2
    terraform
    terragrunt
    poetry
    localstack
    jetbrains.pycharm-community-bin
  ];
}
