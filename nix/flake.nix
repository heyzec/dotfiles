{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    # stylix.url = "github:danth/stylix";

    xremap-flake.url = "github:xremap/nix-flake";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nix-colors, home-manager, ... }@inputs:
  let
    inherit (nixpkgs) lib;
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };

    overlay-stable = final: prev: {
      # unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      # use this variant if unfree packages are needed:
      stable = import nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
    };
    nixpkgs-overlay-stable = ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-stable ]; });


  in
  {
    nixosConfigurations = {
      # The standard configuration (home manager standalone)
      "nixos" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };

        modules = [
          nixpkgs-overlay-stable
          ./.
          ({
            system.nixos.label = 
            if self.sourceInfo ? lastModifiedDate && self.sourceInfo ? shortRev
            then "${lib.substring 0 8 self.sourceInfo.lastModifiedDate}.${self.sourceInfo.shortRev}"
            else lib.warn "Repo is dirty, revision will not be available in system label" "dirty";



          })
        ];
      };

      # The configuration for build-vm (home manager as a module)
      "nixos-vm" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };

        modules = [
          nixpkgs-overlay-stable
          ./.
          home-manager.nixosModules.home-manager
          ({
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.heyzec = {
              imports = [
                ./home/home.nix
              ];
            };
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
          })
        ];
      };
    };


    homeConfigurations = {
      "heyzec" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          nixpkgs-overlay-stable
          # stylix.homeManagerModules.stylix ./home/home.nix
          ./home
        ];
      };
    };
  };
}
# vim: set ts=2 sts=2 sw=2:

