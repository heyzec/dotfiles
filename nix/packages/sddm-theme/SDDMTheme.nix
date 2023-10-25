# This derivation is not longer in use. Maybe can combine with the other one in the future
{
  stdenv, lib, pkgs, fetchurl,
  backgroundURL ? null
}:
let
  buildTheme = { themename, src, backgroundFile }: stdenv.mkDerivation rec {
    name = "sddm-theme-${themename}";

    inherit src;

    dontConfigure = true;
    dontBuild = true;

    # themeIniOverrides = [
    #   {
    #     section = "General";
    #     key = "background";
    #     value = builtins.storePath backgroundFile;
    #   }
    # ];
    # Cant figure out the above
    themeIniOverrides = [];

    installPhase = ''
      dir=$out/share/sddm/themes/${themename}
      runHook preInstall

      mkdir -p $dir
      cp -r * $dir

    ${lib.concatMapStringsSep "\n" (e: ''
      ${pkgs.crudini}/bin/crudini --set --inplace $dir/theme.conf \
        "${e.section}" "${e.key}" "${e.value}"
    '') themeIniOverrides}

      runHook postInstall
    '';
  };

  themes = {
    aerial = {
      pkg = rec {
        themename = "aerial";
        version = "20191018";
        src = pkgs.fetchFromGitHub {
          owner = "3ximus";
          repo = "${themename}-sddm-theme";
          rev = "1a8a5ba00aa4a98fcdc99c9c1547d73a2a64c1bf";
          sha256 = "0f62fqsr73d6fjpfhsdijin9pab0yn0phdyfqasybk50rn59861y";
        };
      };
      deps = with pkgs; [ qt5.qtmultimedia ];
    };
    abstractdark = {
      pkg = rec {
        themename = "abstractdark";
        version = "20161002";
        src = pkgs.fetchFromGitHub {
          owner = "3ximus";
          repo = "${themename}-sddm-theme";
          rev = "e817d4b27981080cd3b398fe928619ffa16c52e7";
          sha256 = "1si141hnp4lr43q36mbl3anlx0a81r8nqlahz3n3l7zmrxb56s2y";
        };
      };
      deps = with pkgs; [];
    };
    sugardark = {
      pkg = rec {
        themename = "sugardark";
        version = "20161002";
        src = pkgs.fetchFromGitHub {
          owner = "MarianArlt";
          repo = "sddm-sugar-dark";
          rev = "ceb2c455663429be03ba62d9f898c571650ef7fe";
          sha256 = "0153z1kylbhc9d12nxy9vpn0spxgrhgy36wy37pk6ysq7akaqlvy";
        };
      };
      deps = with pkgs; [];
    };
  };

  backgroundFile = if backgroundURL == null then null else builtins.fetchurl backgroundURL;
  x = builtins.trace "============================================: " backgroundFile;
  theme = themes.sugardark;

  in buildTheme {
    themename = theme.pkg.themename;
    src = theme.pkg.src;
    backgroundFile = backgroundFile;
  }
