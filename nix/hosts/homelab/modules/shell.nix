{pkgs, ...}: {
  # Shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  heyzec.shell.enable = true;
  # Neovim
  heyzec.neovim.enable = true;
}
