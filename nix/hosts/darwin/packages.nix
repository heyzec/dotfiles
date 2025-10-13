{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    alacritty
    git-crypt
    terminal-notifier # alternative to notify-send
    choose-gui # current alternative to rofi
    flameshot
  ];
}
