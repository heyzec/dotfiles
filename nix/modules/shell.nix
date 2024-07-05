{ lib, pkgs, config, systemSettings, ... }:
{
  options = {
    heyzec.shell = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable zsh with useful tools for a CLI workflow";
      };
    };
  };

  config = let
    cfg = config.heyzec.shell;

    packages = with pkgs; lib.lists.remove null [
      ##### Required by .zshrc #####
      starship
      fzf
      ripgrep
      zoxide
      eza
      bat
      bat-extras.batman


      neovim
      tmux
      (if stdenv.isLinux then ctpv else null) # file previewer for lf, with image support
      lf # terminal file manager

      git
      wget
      zip
      unzip

      xxd
      file
      pstree

      diffr
      lazygit

      ##### Network Diagnostics #####
      nmap # port scanner
      (if stdenv.isLinux then traceroute else null) # track route taken by packets
    ];

    commonConfig = lib.mkIf cfg.enable {
      programs.direnv.enable = true;
      programs.direnv.nix-direnv.enable = true;
    };

    nixosConfig = lib.mkIf cfg.enable {
      environment.systemPackages = packages;
    };

    hmConfig = lib.mkIf cfg.enable {
      home.packages = packages;
    };

  in if !systemSettings.isHome then (lib.recursiveUpdate nixosConfig commonConfig) else (lib.recursiveUpdate hmConfig commonConfig);
}
