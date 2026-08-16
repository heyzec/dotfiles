{
  pkgs,
  userSettings,
  ...
}: {
  programs.zsh.enable = true;
  # zsh has init msg, zsh-newuser-install, annoying
  users.users.root.shell = pkgs.zsh;
  users.users.${userSettings.username}.shell = pkgs.zsh;
  heyzec.shell.enable = true;
}
