# node2nix doesn't support package-lock.json v3, and if we workaround it fails with some cryptic error
# self packaging doesn't work because karabiner-ts uses vite to build, and vite is not in nixpkgs
# using fixed-output derivations and doing npm install in a sandbox gives UNABLE_TO_GET_ISSUER_CERT_LOCALLY
# hence, resorting to Docker
{
  description = "Generates config for Karabiner Elements using karabiner-ts";

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # Hack: run nix develop to generate karabiner.json
      devShells.${system}.default = pkgs.mkShell {
      shellHook = ''
        docker build -t karabiner-ts-docker .
        docker run --rm -v $(pwd):/vol karabiner-ts-docker
        exit
      '';
      };
    };
}

