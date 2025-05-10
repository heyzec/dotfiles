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

    # Two modifications of this wrapper
    # 1. Make it less NixOS-specific by removing Treesitter parsers generated with Nix
    # 2. Add our extra packages to the PATH
    neovim-custom-wrapped = pkgs.callPackage (
      {pkgs, ...}: (pkgs.runCommand
        "neovim-custom-wrapped"
        {buildInputs = [pkgs.makeWrapper];}
        ''
          mkdir $out
          ls $out
          cp -r ${pkgs.neovim-unwrapped}/* $out
          chmod -R +w $out
          rm $out/lib/nvim/parser/*
          wrapProgram $out/bin/nvim \
            --prefix PATH : ${pkgs.lib.makeBinPath extraPackages}
        '')
    ) {};

    nixosConfig = {
      environment.systemPackages = [
        neovim-custom-wrapped
      ];
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
