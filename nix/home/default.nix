{ systemSettings, ... }:
{
  imports = [
    ../overlays
    ./home.nix
    ./fonts.nix
  ] ++ (if systemSettings.system == "x86_64-linux" then [ ./linux ] else []);

  # colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
}
