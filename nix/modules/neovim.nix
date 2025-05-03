{
  config,
  lib,
  pkgs,
  systemSettings,
  ...
}: let
  # These tools also need to be configured in Neovim
  # Edit nvim/lua/heyzec/tooling.lua
  tooling = with pkgs; [
    # Lua for neovim
    lua-language-server # server
    stylua # formatter

    # Nix
    nil # server
    alejandra # formatter

    # Others
    nodePackages.prettier # formatter
    vscode-langservers-extracted # servers for json and more

    # # Shell
    # nodePackages.bash-language-server # LSP
    # shellcheck           # linter
  ];
  extraPackages = with pkgs;
    [
      # C compiler needer for Treesitter to build parsers
      gcc
    ]
    ++ tooling;
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
            paths = [pkgs.neovim-unwrapped];
            nativeBuildInputs = [pkgs.makeBinaryWrapper];
            postBuild = let
              # path = builtins.trace (pkgs.lib.makeBinPath extraPackages);
              path = pkgs.lib.makeBinPath extraPackages;
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
      home.packages = with pkgs; [
        lua-language-server
        stylua
        nil
        alejandra
        nodePackages.prettier
        vscode-langservers-extracted
      ];
    };
  in
    lib.mkIf cfg.enable (
      if !systemSettings.isHome
      then nixosConfig
      else hmConfig
    );
}
