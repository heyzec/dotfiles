{ lib, pkgs, ... }:
{
  options = {
    heyzec.shell = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable zsh with useful tools for a CLI workflow";
      };
    };
  };

  config = {
    programs.zsh = {
      enable = true;
    };
    users.defaultUserShell = pkgs.zsh;

    environment.systemPackages = with pkgs; [
      ##### Required by .zshrc #####
      starship
      fzf
      ripgrep
      zoxide

      tmux
      ctpv # file previewer for lf, with image support
      lf # terminal file manager

      git
      wget
      zip
      unzip

      xxd
      file
      pstree

      ##### Network Diagnostics #####
      nmap # port scanner
      traceroute # track route taken by packets
    ];
  };
}
