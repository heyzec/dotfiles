{ pkgs, ... }:
{
  programs = {
    neovim = {
      package = pkgs.neovim-unwrapped;

      enable = true;
      defaultEditor = true;

      # For mason to install LSPs using npm
      withNodeJs = true;

      # Configure vimrc using non-nix config file
      # configure = {};
    };
  };


  # Add LSPs here
  # NOTE: If would like to make these binaries not available system-wide and only in neovim,
  # will need to create wrapper around neovim package (not override!) to avoid rebuilds
  environment.systemPackages = with pkgs; [
    # == NixOS ==
    nil          # LSP for nix
    nixpkgs-fmt  # External formatter used by nil

    clang-tools_16  # for C++ LSP - clangd
    shellcheck
    nodePackages.bash-language-server
  ];
}

