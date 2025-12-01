{
  description = "Template for a direnv shell, with NodeJS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.05";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        nodejs
        yarn
        # If nodejs is hard-coded to a specific version, node version in yarn also needs to be overridden
        # Otherwise, `node --version` will not align with `yarn node --version`
        # (yarn.override { nodejs = nodejs; })
        typescript-language-server
      ];
    };
  };
}
