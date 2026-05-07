{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    alacritty
    nh
    git-crypt
    terminal-notifier # alternative to notify-send
    choose-gui # current alternative to rofi
    flameshot
  ];
}
