{
  inputs,
  pkgs,
  hasPrivate,
  userSettings,
  ...
}: {
  imports =
    [
      ./hardware
      ./modules
    ]
    ++ (
      if hasPrivate
      then [
        inputs.private.homelab.modules
        inputs.private.homelab.secrets
      ]
      else []
    );

  security.polkit.enable = true;

  # Uncomment to resolve "Failure to copy closures: ... lacks a valid signature"
  # nix.settings.trusted-users = ["bee"]; # https://github.com/NixOS/nix/issues/2127#issuecomment-1465191608

  programs.nh = {
    enable = true;
    flake = userSettings.flakeDir;
  };

  # Enable desktop
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.autoSuspend = false;
  # also imperatively disable auto suspend on idle from Gnome Settings
  environment.gnome.excludePackages = with pkgs; [
    epiphany
  ];

  environment.systemPackages = with pkgs; [
    firefox
    brave
    localsend
    gnupg
    pinentry-tty
    claude-code
    custom.happy-coder
  ];

  # NixOS System Version (Do not touch!!)
  system.stateVersion = "23.05";
}
