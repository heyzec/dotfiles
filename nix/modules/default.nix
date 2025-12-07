# List of locations that can import modules in this folder
# - nix/home/default.nix (imports selected modules)
# - nix/utils.nix (mkNixosSystem imports this file)

{ lib, ... }:
{
  imports = lib.heyzec.umport {
    path = ./.;
  };
}
