{ pkgs, ... }: let
  # Add non-project specific LSPs here
  # Also see nvim/lua/plugins/mason.lua
  extraPackages = with pkgs; [
    # Shell
    nodePackages.bash-language-server # LSP
    shellcheck           # linter

    # Lua for neovim
    lua-language-server # LSP

    # Nix
    cargo gccgo  # Needed by mason-tool-installer to install nil
    nil          # LSP for nix
    nixpkgs-fmt  # External formatter used by nil

    # Misc
    vscode-langservers-extracted # css, eslint, html, json
    yaml-language-server
  ];
in {
  programs = {
    neovim = {
      package = pkgs.symlinkJoin {
        name = "neovim-unwrapped-wrapped";
        paths = [ pkgs.neovim-unwrapped ];
        nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
        postBuild = ''
          wrapProgram $out/bin/nvim \
            --prefix PATH : ${pkgs.lib.makeBinPath extraPackages}
        '';
      };
      enable = true;
      defaultEditor = true;

      # For mason to install LSPs using npm
      withNodeJs = true;

      # Configure vimrc using non-nix config file
      # configure = {};
    };
  };
}

