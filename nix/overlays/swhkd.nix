{
  lib,
  pkgs,
  ...
}: {
  imports = [
    {
      nixpkgs.overlays = [
        (final: prev: {
          swhkd = pkgs.rustPlatform.buildRustPackage rec {
            pname = "swhkd";
            version = "c5c4071459a6465a3743a8bb5bb990e27cdf315b";

            src = pkgs.fetchFromGitHub {
              owner = "waycrate";
              repo = "swhkd";
              rev = version;
              hash = "sha256-Tv9+UBDBuRD3equ2XNmyt3Fm1+9DxkRzqV4M7PWnBLA=";
            };
            patches = [./swhkd.patch];

            cargoHash = "sha256-LBbmFyddyw7vV5voctXq3L4U3Ddbh428j5XbI+td/dg=";

            buildInputs = with pkgs; [
              eudev
            ];

            nativeBuildInputs = with pkgs; [
              scdoc
              pkg-config
            ];

            buildFeatures = [
              # See https://github.com/waycrate/swhkd/issues/310
              "no_rfkill"
            ];

            meta = with lib; {
              description = "Display protocol-independent hotkey daemon";
              longDescription = ''
                A display protocol-independent hotkey daemon made in Rust.
                Uses an easy-to-use configuration system inspired by sxhkd, so you can easily add or remove hotkeys.
                Attempts to be a drop-in replacement of sxhkd, meaning your sxhkd config file should be compatible with swhkd.
              '';
              license = licenses.bsd2;
              maintainers = with maintainers; [mib];
              platforms = platforms.linux;
            };
          };
        })
      ];
    }
  ];
}
