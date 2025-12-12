# This allows us to access custom packages packaged in nix/packages/ with:
# pkgs.custom.<program>
final: prev: {
  custom = import ../packages {pkgs = final;};
}
