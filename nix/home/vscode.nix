{
  pkgs,
  config,
  userSettings,
  ...
}: let
  username = userSettings.username;
  root = "/Users/${username}/dotfiles/vscode";

  # Define extensions that are not in nixpkgs here
  extra = {
    periscope = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      # JoshMu.periscope
      mktplcRef = {
        name = "periscope";
        publisher = "JoshMu";
        version = "1.11.1";
        hash = "sha256-Eed3vcmwbxThd/MmImgYzQHhkUe2O0OJszSUHPsknlc=";
      };
    };
    inherit-profile = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      # alexthomson.inherit-profile
      mktplcRef = {
        name = "inherit-profile";
        publisher = "alexthomson";
        version = "0.6.0";
        hash = "sha256-mKic9Sjarpm6JPSzzTzPUxL4knq6YEVA1QwtpYE48EI=";
      };
    };
    vscode-pbkit = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
      # pbkit.vscode-pbkit
      mktplcRef = {
        name = "vscode-pbkit";
        publisher = "pbkit";
        version = "0.0.8";
        hash = "sha256-xM6yKLx9rntZZO0VMGrpyvIFhNAV5pFWIFrUqKglZyI=";
      };
    };
  };

  # List of extensions used in all profiles
  defaultExtensions = with pkgs.vscode-extensions; [
    asvetliakov.vscode-neovim
    waderyan.gitblame
    usernamehw.errorlens
    esbenp.prettier-vscode
    mkhl.direnv
    extra.periscope
  ];

  mkProfile = profile: extensions: {
    extensions =
      defaultExtensions
      ++ extensions
      ++
      # Workaround until https://github.com/microsoft/vscode/issues/188612 fixed
      [extra.inherit-profile];
    keybindings = config.lib.file.mkOutOfStoreSymlink "${root}/keybindings.jsonc";
    userSettings = config.lib.file.mkOutOfStoreSymlink "${root}/settings-${profile}.jsonc";
  };
in {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false; # Whether extensions can be modified by Visual Studio Code

    # Ensure for each non-default profile, ${root}/settings-<profile>.jsonc has been created
    profiles = {
      "default" = {
        extensions = defaultExtensions;
      };
      # "Python" = mkProfile "Python" (with pkgs.vscode-extensions; [
      #   ms-python.python
      #   ms-python.vscode-pylance
      #   ms-python.debugpy
      # ]);
      # "TypeScript" = mkProfile "TypeScript" (with pkgs.vscode-extensions; [
      #   yoavbls.pretty-ts-errors
      # ]);
      # "C" = mkProfile "C" (with pkgs.vscode-extensions; [
      #   llvm-vs-code-extensions.vscode-clangd
      # ]);
      "Go" = mkProfile "Go" (with pkgs.vscode-extensions; [
        golang.go
        extra.vscode-pbkit
      ]);
    };
  };
}
