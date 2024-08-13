{
pkgs
, fetchFromGitHub
, python
, requests
, pycryptodome
}:
let
  src = fetchFromGitHub {
    owner = "zerotypic";
    repo = "wasg-register";
    rev = "e2ebe3a7134da7c6509c6c1739eb9594ca8eff6c";
    hash = "sha256-1zuXDXPd7iTT+3KuEHoyMHzDhxFr1H8oAYB0/vesFBY=";
  };
  python-with-packages = python.withPackages (ps: (with ps; [
    requests
    pycryptodome
  ]));
in pkgs.writeScriptBin "wasg-register" ''
  ${python-with-packages}/bin/python ${src}/wasg-register.py "$@"
''
