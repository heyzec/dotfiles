{pkgs}:
pkgs.mkShell {
  packages = with pkgs; [
    ragenix
  ];
}
