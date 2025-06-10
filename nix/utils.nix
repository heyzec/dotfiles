{
  self,
  inputs,
}: let
  # Override lib with custom utilities
  # https://github.com/bangedorrunt/nix/blob/tdt/flake.nix#L94-L97
  mkLib = nixpkgs:
    nixpkgs.lib.extend
    (self: super:
      {
        heyzec = import ./lib {
          # TODO: Remove pkgs as this is now hardcoded to x86_64-linux
          pkgs = pkgsForSystem "x86_64-linux";
          lib = self;
        };
      }
      // inputs.home-manager.lib);
  lib = mkLib inputs.nixpkgs;

  # Needed by home manager in standalone mode (?)
  pkgsForSystem = system:
    import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };

  # Additionally, pass these arguments to each module
  getSpecialArgs = name: let
    inherit (import ./settings.nix) systemSettings userSettings specificSettings;
  in {
    inherit inputs lib self;
    systemSettings =
      systemSettings
      // (
        if builtins.hasAttr name specificSettings
        then specificSettings.${name}.systemSettings
        else {}
      );
    userSettings =
      userSettings
      // (
        if builtins.hasAttr name specificSettings
        then specificSettings.${name}.userSettings
        else {}
      );
  };
in rec {
  mkNixosSystem = name: {modules}: let
    specialArgs = getSpecialArgs name;
  in
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = specialArgs;
      system = specialArgs.systemSettings.system;
      modules =
        [
          ./modules
          ./overlays
        ]
        ++ modules;
    };

  mkNixosSystemWithHm = nameNixos: nameHm: {
    username,
    modulesNixos,
    modulesHm,
  }: let
    specialArgsHm = getSpecialArgs nameHm;
  in
    mkNixosSystem nameNixos {
      modules =
        [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = lib.recursiveUpdate specialArgsHm {systemSettings.isHome = true;};
              users.${username} = {
                imports = modulesHm;
              };
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }
        ]
        ++ modulesNixos;
    };

  mkHmConfig = name: {modules}: let
    specialArgs = getSpecialArgs name;
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsForSystem specialArgs.systemSettings.system;
      extraSpecialArgs = lib.recursiveUpdate specialArgs {systemSettings.isHome = true;};
      modules =
        [
          ./overlays
        ]
        ++ modules;
    };

  mkDarwinSystem = name: {modules}: let
    specialArgs = getSpecialArgs name;
  in
    inputs.nix-darwin.lib.darwinSystem {
      inherit specialArgs modules;
    };
}
