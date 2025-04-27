{
  description = "Flake of heyzec";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
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

  # Don't add parameters to within { ... }, explicitly index it from inputs instead
  outputs = { self, ... }@inputs: let
    # ---- SYSTEM SETTINGS ---- #
    systemSettings = {
      system = "x86_64-linux";      # system arch
      hostname = "nixie";
      timezone = "Asia/Singapore";
      locale = "en_SG.UTF-8";
      isHome = false;
    };

    # ----- USER SETTINGS ----- #
    userSettings = rec {
      username = "heyzec";
      homeDir = "/home/${username}";
      dotfilesDir = "~/dotfiles";              # path to dotfiles repo, used by vm (good to start with ~)
      flakeDir = "/home/heyzec/dotfiles/nix";  # path to flake repo, used by nh
    };

    # ----- Override SYSTEM and USER SETTINGS on a per-host basis here ----- #
    specificSettings = {
      "homelab" = {
        systemSettings.system = "aarch64-linux";
      };
      "darwin" = {
        systemSettings.system = "x86_64-darwin";
        userSettings.homeDir = "/Users/heyzec";
      };
    };

    # Override lib with custom utilities
    # https://github.com/bangedorrunt/nix/blob/tdt/flake.nix#L94-L97
    mkLib = nixpkgs:
      nixpkgs.lib.extend
      (self: super: {heyzec = import ./lib { pkgs = pkgsForSystem "x86_64-linux"; lib = self; }; } // inputs.home-manager.lib);
    lib = mkLib inputs.nixpkgs;

    # Needed by home manager in standalone mode (?)
    pkgsForSystem = system : import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };

    # This allows us to access stable packages:
    # - unstable: pkgs.<program>
    # - stable:   pkgs.stable.<program>
    nixpkgs-stable-module = ({
      nixpkgs.overlays = [
        (final: prev: {
          stable = import inputs.nixpkgs-stable {
            system = systemSettings.system;
            config.allowUnfree = true;
          };
        })
      ];
    });

    label-generation-module = ({
      system.nixos.label =
      if self.sourceInfo ? lastModifiedDate && self.sourceInfo ? shortRev
      then "${inputs.nixpkgs.lib.substring 0 8 self.sourceInfo.lastModifiedDate}.${self.sourceInfo.shortRev}"
      else inputs.nixpkgs.lib.warn "Repo is dirty, revision will not be available in system label" "dirty";
      });

    # Additional pass these arguments to each module
    customArgs = {
      inherit inputs;
      inherit lib;
    };

    getSpecialArgs = name :
      if builtins.hasAttr name specificSettings then
        customArgs // {
          systemSettings = systemSettings // specificSettings.${name}.systemSettings;
          userSettings = userSettings // specificSettings.${name}.userSettings;
        }
      else customArgs // {
        systemSettings = systemSettings;
        userSettings = userSettings;
      };
  in
  {
    legacyPackages."x86_64-darwin" = pkgsForSystem "x86_64-darwin";

    nixosConfigurations = {
      # The standard configuration (home manager standalone)
      "nixie" = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = getSpecialArgs "nixie";
        modules = [
          ./modules
          ./hosts/nixie
          nixpkgs-stable-module
          label-generation-module
        ];
      };

      # The configuration for build-vm (home manager as a module)
      "nixie-vm" = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = getSpecialArgs "nixie-vm";
        modules = [
          ./modules
          ./hosts/nixie
          nixpkgs-stable-module
          inputs.home-manager.nixosModules.home-manager
          ({
            home-manager = {
              extraSpecialArgs = getSpecialArgs "heyzec";
              users = {
                ${userSettings.username} = {
                  imports = [
                    ./home
                  ];
                };
              };
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          })
        ];
      };

      "homelab" = inputs.nixpkgs.lib.nixosSystem {
        system = (getSpecialArgs "homelab").systemSettings.system;
        modules = [
          ./modules
          ./hosts/homelab
          inputs.nixos-hardware.nixosModules.raspberry-pi-4
        ];
        specialArgs = getSpecialArgs "homelab";
      };
    };

    homeConfigurations = {
      "heyzec" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsForSystem (getSpecialArgs "heyzec").systemSettings.system;
        extraSpecialArgs = lib.recursiveUpdate (getSpecialArgs "heyzec") { systemSettings.isHome = true; };
        modules = [
          ./home
          ./modules/shell.nix
          ./modules/neovim.nix
          nixpkgs-stable-module
        ];
      };

      "darwin" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsForSystem (getSpecialArgs "darwin").systemSettings.system;
        extraSpecialArgs = lib.recursiveUpdate (getSpecialArgs "darwin") { systemSettings.isHome = true; };
        modules = [
          ./home
          ./modules/shell.nix
          nixpkgs-stable-module
        ];
      };
    };

    darwinConfigurations = {
      "darwin" = inputs.nix-darwin.lib.darwinSystem {
        specialArgs = getSpecialArgs "darwin";
        modules = [
          ./hosts/darwin
        ];
      };
    };
  };
}

# vim: set ts=2 sts=2 sw=2:
