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
      "nixie" = mkNixosSystem "nixie" {modules = [./nix/hosts/nixie];};
      # The configuration for build-vm (home manager as a module)
      "nixie-vm" = mkNixosSystemWithHm "nixie-vm" "heyzec" {
        username = "heyzec";
        modulesNixos = [./nix/hosts/nixie];
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
