{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    starship
    fzf
    ripgrep
    zoxide

    eza
    bat
    bat-extras.batman
  ];
}

