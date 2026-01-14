{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    # Whether extensions can be modified by Visual Studio Code
    mutableExtensionsDir = false;

    # Until we are able to declaratively install extensions for each profile, install all extensions via VSCode
    # This is because once ~/.vscode/extensions/extensions.json is generated, it will no longer be updated by home-manager
    profiles = let
      defaultExtensions = with pkgs.vscode-extensions; [
        asvetliakov.vscode-neovim
        waderyan.gitblame
        usernamehw.errorlens
        esbenp.prettier-vscode
        mkhl.direnv
        (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
          # JoshMu.periscope
          mktplcRef = {
            name = "periscope";
            publisher = "JoshMu";
            version = "1.11.1";
            hash = "sha256-Eed3vcmwbxThd/MmImgYzQHhkUe2O0OJszSUHPsknlc=";
          };
        })
      ];
      extendWith = moreExtensions: defaultExtensions ++ moreExtensions;
    in {
      "default" = {
        extensions = defaultExtensions;
      };
      "Python" = {
        extensions = extendWith (with pkgs.vscode-extensions; [
          ms-python.python
          ms-python.vscode-pylance
          ms-python.debugpy
        ]);
      };
      "TypeScript" = {
        extensions = extendWith (with pkgs.vscode-extensions; [
          yoavbls.pretty-ts-errors
        ]);
      };
      "C/C++" = {
        extensions = extendWith (with pkgs.vscode-extensions; [
          llvm-vs-code-extensions.vscode-clangd
        ]);
      };
      "Go" = {
        extensions = extendWith (with pkgs.vscode-extensions; [
          golang.go
        ]);
      };
    };
  };
}
