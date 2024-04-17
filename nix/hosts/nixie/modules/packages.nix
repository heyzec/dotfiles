{ config, pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    ################################################################################
    ##### Command-line Utilities
    ################################################################################

    ##### Command line utilities: Basics #####
    git
    git-crypt
  ];
}
