final: prev: {
  vscode-extensions =
    prev.vscode-extensions
    // (let
      pname = "vscode-neovim";
      version = "1.18.24";
      publisher = "asvetliakov";
      extId = "${publisher}.${pname}";
    in {
      asvetliakov.vscode-neovim = prev.buildNpmPackage rec {
        inherit pname version;
        name = "${pname}-${version}";

        src = prev.fetchFromGitHub {
          owner = "vscode-neovim";
          repo = "vscode-neovim";
          # Use https://github.com/vscode-neovim/vscode-neovim/pull/2515
          rev = "56c8c7cc30d70ef76f5c57117e14b20c34d0f5b1";
          hash = "sha256-tmZHZi4If/FUmTaZ+BV8vEWzaFbVIk3XK8TKk1gK/90=";
        };
        # stylua's npm install script will trigger a fetch from GitHub Releases
        # this patch removes the dependency on stylua
        patches = [./vscode-neovim.patch];
        npmDepsHash = "sha256-8093rvgtftgJxEt08xCm9JO+cfYHw1l2c8EBkEbgst4=";

        # NODE_TLS_REJECT_UNAUTHORIZED = "0";

        nativeBuildInputs = with prev;
          [
            nodejs
            npmHooks.npmConfigHook
            vsce
            python3
            unzip

            pkg-config
          ]
          ++ lib.optionals stdenv.isDarwin [clang_20]; # clang_21 breaks @vscode/vsce's optional dependency keytar

        buildInputs = with prev; [
          libsecret
        ];

        buildPhase = ''
          vsce package --out ./${name}-${version}.vsix
          mkdir -p unpacked
          unzip ./${name}-${version}.vsix 'extension/*' -d unpacked
        '';

        installPrefix = "share/vscode/extensions/${extId}";

        installPhase = ''
          mkdir -p $out/$installPrefix
          mv ./unpacked/extension/* $out/$installPrefix
        '';

        passthru = {
          vscodeExtPublisher = publisher;
          vscodeExtName = name;
          vscodeExtUniqueId = extId;
        };
      };
    });
}
