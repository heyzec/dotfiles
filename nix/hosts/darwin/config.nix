{ pkgs, config, ... }:
{
  services.nix-daemon.enable = true;
  nixpkgs.hostPlatform = "x86_64-darwin";

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    alacritty
  ];

  system.activationScripts.postUserActivation.text = ''
    # Fix to automatically add applications to launchers
    # https://github.com/LnL7/nix-darwin/issues/214#issuecomment-2050027696
    rsyncArgs="--archive --checksum --chmod=-w --copy-unsafe-links --delete"
    apps_source="${config.system.build.applications}/Applications"
    moniker="Nix Trampolines"
    app_target_base="$HOME/Applications"
    app_target="$app_target_base/$moniker"
    mkdir -p "$app_target"
    ${pkgs.rsync}/bin/rsync $rsyncArgs "$apps_source/" "$app_target"

    # Following line should allow us to avoid a logout/login cycle
    # https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
