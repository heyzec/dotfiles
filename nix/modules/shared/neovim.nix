{
  lib,
  pkgs,
  ...
}: let
  # These tools also need to be configured in Neovim
  # Edit nvim/lua/heyzec/tooling.lua
  tooling = with pkgs; [
    # Lua for neovim
    lua-language-server # server
    stylua # formatter

    # Nix
    nixd # server
    alejandra # formatter

    # Config files
    vscode-langservers-extracted # server (includes html, css, json, eslint)
    yaml-language-server # server

    # Others
    nodePackages.prettier # formatter

    # # Shell
    # nodePackages.bash-language-server # LSP
    # shellcheck           # linter
  ];
  extraPackages = with pkgs;
    [
      # C compiler needed for Treesitter to build parsers
      gcc
      tree-sitter
      # Node needed for some Neovim plugins, e.g. Copilot
      nodejs
      # Rust needed by Mason to install some tools, e.g. alejandra
      cargo
    ]
    ++ tooling;
in {
  options = {
    heyzec.neovim = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable the custom Neovim module.";
      };
      defaultEditor = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "When enabled, configures neovim to be the default editor using the EDITOR environment variable.";
      };
      package = lib.mkOption {
        type = lib.types.package;
      };
    };
  };
  config = let
    # Two modifications of this wrapper
    # 1. Make it less NixOS-specific by removing Treesitter parsers generated with Nix
    # 2. Add our extra packages to the PATH
    neovim-custom-wrapped = pkgs.callPackage (
      {pkgs, ...}: (pkgs.runCommand
        "neovim-custom-wrapped"
        {buildInputs = [pkgs.makeWrapper];}
        ''
          mkdir $out
          cp -r ${pkgs.neovim-unwrapped}/* $out
          chmod -R +w $out
          rm $out/lib/nvim/parser/*
          wrapProgram $out/bin/nvim \
            --prefix PATH : ${pkgs.lib.makeBinPath extraPackages}
        '')
    ) {};
  in {
    heyzec.neovim.package = neovim-custom-wrapped;
  };
}
