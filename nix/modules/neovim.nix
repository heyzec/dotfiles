{ config, lib, pkgs, systemSettings, ... }: let
  # Add non-project specific LSPs here
  # Also see nvim/lua/plugins/mason.lua
  extraPackages = with pkgs; [
    # # Shell
    # nodePackages.bash-language-server # LSP
    # shellcheck           # linter

    # # Lua for neovim
    # lua-language-server # LSP

    # # Nix
    # cargo gccgo  # Needed by mason-tool-installer to install nil
    # nil          # LSP for nix
    # nixpkgs-fmt  # External formatter used by nil

    # # Misc
    # vscode-langservers-extracted # css, eslint, html, json
    # yaml-language-server

    # No C compiler found! "cc", "gcc", "clang", "cl", "zig" are not executable.
    # We need a compiler
    gcc
  ];
in {
  options = {
    heyzec.neovim = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
    };
  };
  config = let
    cfg = config.heyzec.neovim;

    nixosConfig = {
      programs = {
        # A little hacky because
        # 1. we are trying to force the output of our ...pkgs.symlinkJoin {}
        #   to fit the expectations of pkgs.neovim-unwrapped. We are
        # 2. We are exposed to API changes of the wrapper, if people add extra fields
        # 3. Our object may no longer behave as expected with regards to module options, e.g.
        # with NodeJs no longer work (untested)
        # Consider using environment.systemPackages instead
        neovim = {
          # package = pkgs.neovim-unwrapped;
          package = pkgs.symlinkJoin {
            name = "neovim-unwrapped-wrapped";
            meta = pkgs.neovim-unwrapped.meta;
            lua = pkgs.neovim-unwrapped.lua;
            paths = [ pkgs.neovim-unwrapped ];
            nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
            postBuild = let
              # path = builtins.trace (pkgs.lib.makeBinPath extraPackages);
              path = (pkgs.lib.makeBinPath extraPackages);
            in ''
              wrapProgram $out/bin/nvim \
                --prefix PATH : ${path}
            '';
          };
          # package = pkgs.neovim-unwrapped.overrideAttrs {
          #   foo = "bar";
          # };
          enable = true;
          defaultEditor = true;

          # For mason to install LSPs using npm
          withNodeJs = true;

          # Configure vimrc using non-nix config file
          # configure = {};
        };
      };
    };

    hmConfig = {
      xdg.configFile."nvim/lua/generated.lua" = {
        text = ''
          test file generated
        '';
      };
    };

  in lib.mkIf cfg.enable ( if !systemSettings.isHome then nixosConfig else hmConfig);
}
