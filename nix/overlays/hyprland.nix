{ pkgs, ... }:
let
  # nixpkgs-old = import (builtins.fetchGit {
  #    # Descriptive name to make the store path easier to identify
  #    name = "nix_pkgs_with_singularity";
  #    url = "https://github.com/NixOS/nixpkgs/";
  #    ref = "refs/heads/nixpkgs-unstable";
  #    rev = "8cad3dbe48029cb9def5cdb2409a6c80d3acfe2e";
  #  }) { };
    nixpkgs-old1 = builtins.fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/50a7139fbd1acd4a3d4cfa695e694c529dd26f3a.tar.gz";
        sha256 = "1rh75qfcdbczm2rdzqni21xj0wc8f92mhnpwq5mv3z0yy8f35krl";
     };
    nixpkgs-old2 = import (nixpkgs-old1) { inherit (pkgs) system; };
in
{
  nixpkgs.overlays = [
    (final: prev: {
      hyprland = nixpkgs-old2.hyprland;
      xdg-desktop-portal-hyprland = nixpkgs-old2.xdg-desktop-portal-hyprland;
      hyprland-share-picker = nixpkgs-old2.hyprland-share-picker;
    })
  ];

  imports = [
    "${nixpkgs-old1}/nixos/modules/programs/hyprland.nix"
  ];
  disabledModules = [
    "programs/hyprland.nix"
  ];
}
