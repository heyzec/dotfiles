{
  stdenv,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  gtk3,
  libepoxy,
  wayland,
  spdlog,
  yaml-cpp,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "wayland-displays";

  src = fetchFromGitHub {
    owner = "heyzec";
    repo = "wayland-displays";
    rev = "11a131eb388d94b38d2256dad72752c3ccff7cb3";
    hash = "sha256-fwW7O8RvgEf1v+7lxg7Fed1UB9XVB7lPs4pCl2vmpd0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    gtk3
    libepoxy
    wayland
    spdlog
    yaml-cpp
  ];
})
