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
        nativeBuildInputs = [ pkgs.makeWrapper ];
        # Using lower-level makeShellWrapper instead of wrapProgram
        # The vim-tmux-navigator plugin will not work when wrapProgram changes the command to .nvim-wrapped
        # See https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh, look for `hidden` variable
        # See https://github.com/christoomey/vim-tmux-navigator/blob/master/vim-tmux-navigator.tmux, look for `is-vim` variable
        postBuild = ''
          makeShellWrapper "${pkgs.neovim-unwrapped}/bin/nvim" "$out/bin/nvim-temp" \
            --prefix PATH : ${pkgs.lib.makeBinPath extraPackages}
          mv "$out/bin/nvim-temp" "$out/bin/nvim"
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

