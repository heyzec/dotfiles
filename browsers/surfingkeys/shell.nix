{pkgs}:
pkgs.mkShell {
  packages = with pkgs; [
    nodejs
    typescript-language-server
  ];
}
