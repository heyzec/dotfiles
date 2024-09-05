{ pkgs, ... }:
{
  home.packages = with pkgs; [
    awscli2
    terraform
    terragrunt
    poetry
    localstack
    jetbrains.pycharm-community-bin
    powershell
    postman
  ];
}
