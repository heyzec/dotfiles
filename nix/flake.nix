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
    };

    # ----- USER SETTINGS ----- #
    userSettings = {
      username = "heyzec";
      dotfilesDir = "~/dotfiles";              # path to dotfiles repo, used by vm (good to start with ~)
      flakeDir = "/home/heyzec/dotfiles/nix";  # path to flake repo, used by nh
    };

      pkgsForSystem = system: import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };



    specificSettings = {
      "hostlab" = {
        systemSettings = {
          system = "aarch64-linux";
        };
      };
    };

    # Override lib with custom utilities
    # https://github.com/bangedorrunt/nix/blob/tdt/flake.nix#L94-L97
    mkLib = nixpkgs:
      nixpkgs.lib.extend
      (self: super: {heyzec = import ./lib { pkgs = getPkgs "x86_64-linux"; lib = self; }; } // inputs.home-manager.lib);
    lib = mkLib inputs.nixpkgs;

    # Needed by home manager in standalone mode
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
      };
    };
    getPkgs = system : import inputs.nixpkgs {
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
        systemSettings = specificSettings.${name}.systemSettings // systemSettings;
        userSettings = specificSettings.${name}.userSettings // userSettings;
      } else customArgs // {
        systemSettings = systemSettings;
        userSettings = userSettings;
      };
  in
    {
  legacyPackages."x86_64-darwin" = pkgsForSystem "x86_64-darwin";



} // {

    packages."x86_64-darwin".homeConfigurations = {
      "heyzec" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
        # extraSpecialArgs = getSpecialArgs "";
        extraSpecialArgs =  customArgs // { inherit userSettings; inherit systemSettings; };
        modules = [
          ./home
          nixpkgs-stable-module
        ];
      };

      "darwin" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages."x86_64-darwin";
        extraSpecialArgs = getSpecialArgs "" // { systemSettings.system = "x86_64-darwin"; };
        modules = [
          ./home
          nixpkgs-stable-module
        ];
      };
    };
  };
}
# vim: set ts=2 sts=2 sw=2:

