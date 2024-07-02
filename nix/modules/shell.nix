{ lib, pkgs, config, ... }:
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

  config = lib.mkIf config.heyzec.shell.enable (let
    packages = with pkgs; [
      ##### Required by .zshrc #####
      starship
      fzf
      ripgrep
      zoxide
      eza
      bat
      bat-extras.batman


      tmux
      # ctpv # file previewer for lf, with image support
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
      # traceroute # track route taken by packets
    ];

    isHome = true;
  in {
    # This config is available in both NixOS and home-manager
    # programs.zsh.enable = true;

    # users.defaultUserShell = pkgs.zsh;

    # Enable nix-direnv for dev shells
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

  }
  // (if isHome then
  {
    home.packages = packages;
  } else {
    environment.systemPackages = packages;
  }
  ));
}
