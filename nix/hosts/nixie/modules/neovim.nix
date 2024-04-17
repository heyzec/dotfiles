{ lib, pkgs, ... }:
{
  programs = {
    neovim = {


      enable = true;
      defaultEditor = true;


      # Configure vimrc using non-nix config file
      # configure = {};
    };
  };
}

