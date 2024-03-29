{ inputs, ... }:
{
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./firefox.nix
    ./home.nix
    ./gtk.nix
    ./joplin.nix
    ./symlinks.nix
    ./mime.nix
    ./packages.nix
    ./services.nix
    ./systemd.nix
    ./theming.nix
  ];

  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
}
