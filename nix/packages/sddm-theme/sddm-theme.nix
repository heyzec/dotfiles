# This file this taken from https://www.youtube.com/watch?v=m_6eqpKrtxk
{ pkgs }:

let
  imgLink = "https://wallpaperaccess.com/full/674253.png";

  image = pkgs.fetchurl {
    url = imgLink;
    sha256 = "sha256-SLEh6PSkBxsPAzkJyUTaVGFVh51wqI9zJN7ekGZLrfU=";
  };
in
pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-sugar-dark";
    rev = "ceb2c455663429be03ba62d9f898c571650ef7fe";
    sha256 = "0153z1kylbhc9d12nxy9vpn0spxgrhgy36wy37pk6ysq7akaqlvy";
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
    cd $out/
    rm Background.jpg
    cp -r ${image} $out/Background.jpg
   '';
}
