{
  description = "Flake of heyzec";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";
  };

  # Don't add parameters to within { ... }, explicitly index it from inputs instead
  outputs = { self, ... }@inputs: let
    # ---- SYSTEM SETTINGS ---- #
    systemSettings = {
      system = "x86_64-linux";      # system arch
      hostname = "nixie";
      timezone = "Asia/Singapore";
      locale = "en_SG.UTF-8";
    };

    # ----- USER SETTINGS ----- #
    userSettings = {
      username = "heyzec";
      dotfilesDir = "~/dotfiles";              # path to dotfiles repo, used by vm (good to start with ~)
      flakeDir = "/home/heyzec/dotfiles/nix";  # path to flake repo, used by nh
    };

    # Needed by home manager in standalone mode
    pkgs = import inputs.nixpkgs {
      system = systemSettings.system;
      config = {
        allowUnfree = true;
      };
    };

    # This allows us to access stable packages:
    # - unstable: pkgs.<program>
    # - stable:   pkgs.stable.<program>
    overlay-stable = final: prev: {
      stable = import inputs.nixpkgs-stable {
        system = systemSettings.system;
        config.allowUnfree = true;
      };
    };
    nixpkgs-overlay-stable = ({ config, pkgs, ... }: { nixpkgs.overlays = [ overlay-stable ]; });

  in
  {
    nixosConfigurations = {
      # The standard configuration (home manager standalone)
      "nixie" = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          nixpkgs-overlay-stable
          ./modules
          ./hosts/nixie
          ({
            system.nixos.label = 
            if self.sourceInfo ? lastModifiedDate && self.sourceInfo ? shortRev
            then "${inputs.nixpkgs.lib.substring 0 8 self.sourceInfo.lastModifiedDate}.${self.sourceInfo.shortRev}"
            else inputs.nixpkgs.lib.warn "Repo is dirty, revision will not be available in system label" "dirty";
          })
        ];
        specialArgs = {
          inherit inputs;
          inherit systemSettings;
          inherit userSettings;
        };
      };

      # The configuration for build-vm (home manager as a module)
      "nixie-vm" = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          nixpkgs-overlay-stable
          ./modules
          ./hosts/nixie
          inputs.home-manager.nixosModules.home-manager
          ({
            home-manager = {
              users = {
                ${userSettings.username} = {
                  imports = [
                    ./home
                  ];
                };
              };
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit inputs;
                inherit systemSettings;
                inherit userSettings;
              };
            };
          })
        ];
        specialArgs = {
          inherit inputs;
          inherit systemSettings;
          inherit userSettings;
        };
      };

      "homelab" = inputs.nixpkgs-stable.lib.nixosSystem {
        system = "aarch64-linux";

        modules = [
          ./hosts/homelab
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
        ];
        specialArgs = {
          inherit inputs;
          inherit systemSettings;
          inherit userSettings;
        };
      };
    };


    homeConfigurations = {
      "heyzec" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          nixpkgs-overlay-stable
          # stylix.homeManagerModules.stylix ./home/home.nix
          ./home
        ];
        extraSpecialArgs = {
          inherit inputs;
          inherit systemSettings;
          inherit userSettings;
        };
      };
    };
  };
}
# vim: set ts=2 sts=2 sw=2:

