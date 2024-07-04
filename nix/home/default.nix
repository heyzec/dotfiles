{ inputs, ... }:
{
  imports = [
    ../overlays

    inputs.nix-colors.homeManagerModules.default
    ./AutoArchiver.nix
    ./firefox.nix
    ./home.nix
    ./gtk.nix
    ./joplin.nix
    ./symlinks.nix
    ./thunar.nix
    ./mime.nix
    ./packages.nix
    ./services.nix
    ./systemd.nix
    ./theming.nix
  ];

  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
}
