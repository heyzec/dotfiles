{
  description = "Flake of heyzec";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {self, ...} @ inputs: let
    utils = (import nix/utils.nix) {inherit self inputs;};
    inherit (utils) mkNixosSystem mkNixosSystemWithHm mkHmConfig mkDarwinSystem;
  in {
    nixosConfigurations = {
      # The standard configuration (home manager standalone)
      "devpad" = mkNixosSystem "devpad" {modules = [./nix/hosts/devpad];};
      # The configuration for build-vm (home manager as a module)
      "devpad-vm" = mkNixosSystemWithHm "devpad-vm" "heyzec" {
        username = "heyzec";
        modulesNixos = [./nix/hosts/devpad];
        modulesHm = [./nix/home];
      };
      "homelab" = mkNixosSystem "homelab" {modules = [./nix/hosts/homelab];};
    };

    homeConfigurations = {
      "heyzec" = mkHmConfig "heyzec" {modules = [./nix/home];};
      "darwin" = mkHmConfig "darwin" {modules = [./nix/home];};
    };

    darwinConfigurations = {
      "darwin" = mkDarwinSystem "darwin" {modules = [./nix/hosts/darwin];};
    };
  };
}
