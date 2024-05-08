{ inputs, ... }:
{
  imports = [
    ../overlays

    inputs.nix-colors.homeManagerModules.default
    ./AutoArchiver.nix
    ./firefox.nix
    ./fonts.nix
    ./gtk.nix
    ./home.nix
    ./joplin.nix
    ./mime.nix
    ./packages.nix
    ./services.nix
    ./symlinks.nix
    ./systemd.nix
    ./theming.nix
    ./thunar.nix
    ./vscode.nix
  ];

  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;
}
