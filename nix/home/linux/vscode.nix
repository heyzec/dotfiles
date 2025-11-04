{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    # Whether extensions can be modified by Visual Studio Code
    mutableExtensionsDir = true;

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
      # "Python" = {
      #   extensions = extendWith (with pkgs.vscode-extensions; [
      #     ms-python.python
      #     ms-python.vscode-pylance
      #     ms-python.debugpy
      #   ]);
      # };
      "Typst" = {
        extensions = extendWith (with pkgs.vscode-extensions; [
          myriad-dreamin.tinymist
          streetsidesoftware.code-spell-checker
        ]);
      };
      "C/C++" = {
        extensions = extendWith (with pkgs.vscode-extensions; [
          llvm-vs-code-extensions.vscode-clangd
        ]);
      };
      # TODO: fix profile with space
      # "Source Academy" = {
      #   extensions = extendWith (with pkgs.vscode-extensions; [
      #     elixir-lsp.vscode-elixir-ls # JakeBecker.elixir-ls
      #     firefox-devtools.vscode-firefox-debug
      #     ms-python.debugpy
      #     # pgourlain.erlang
      #   ]);
      # };
      "TypeScript" = {
        extensions = extendWith (with pkgs.vscode-extensions; [
          yoavbls.pretty-ts-errors
        ]);
      };
    };
  };
}
