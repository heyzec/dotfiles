{ pkgs, ... }:
{
  systemd.services."heyzecBot" = {
    serviceConfig = {
      WorkingDirectory = "/home/pi/heyzecBot";
      ExecStart = let
        importhook = ps: let
          pname = "importhook";
          version = "1.0.9";
        in ps.buildPythonPackage {
          inherit pname version;

          src = pkgs.fetchFromGitHub {
            owner = "rkargon";
            repo = "importhook";
            rev = "5c8df7a9c5060eb66f32f2c44bb60ba0aaf65d2f";
            sha256 = "sha256-WyScHcAOEO0ASEF8IWHoPSPZGnCPq8b+eGSNtV/WNSY=";
          };
          doCheck = false;
        };

        # languagemodels = ps: let
        #   pname = "languagemodels";
        #   version = "0.20.0";
        # in ps.buildPythonPackage {
        #   inherit pname version;
        #   src = pkgs.fetchPypi {
        #     inherit pname version;
        #     sha256 = "sha256-kHNSAgGD1tmLMmozIqEstGrtNIhH3XrRkGM9lHpL59g=";
        #   };
        #   propagatedBuildInputs = with ps; [
        #     requests
        #     huggingface-hub
        #     tokenizers
        #     ctranslate2
        #   ];
        #   # A hack needed to fix missing readme.md
        #   postPatch = ''
        #     touch readme.md
        #   '';
        #   doCheck = false;
        # };

        python-packages = ps: with ps; [
          python-dotenv

          (importhook ps)

          python-telegram-bot

          pytest
          (pytest-asyncio.overrideAttrs {
            src = pkgs.fetchFromGitHub {
              owner = "pytest-dev";
              repo = "pytest-asyncio";
              rev = "refs/tags/v0.21.1";
              hash = "sha256-Wpo8MpCPGiXrckT2x5/yBYtGlzso/L2urG7yGc7SPkA=";
            };
          })
          telethon

          lxml
          pandas

          googlemaps
          gspread
          oauth2client

          openai
          # (languagemodels ps)
        ];
        python = pkgs.python311.withPackages python-packages;
      in
        "${python.interpreter} main.py";
    };
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
  };
}
