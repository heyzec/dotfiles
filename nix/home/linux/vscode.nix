{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    # Whether extensions can be modified by Visual Studio Code
    mutableExtensionsDir = true;

    # Until we are able to declaratively install extensions for each profile, install all extensions via VSCode
    # This is because once ~/.vscode/extensions/extensions.json is generated, it will no longer be updated by home-manager
    # extensions = with pkgs.vscode-extensions; [
    #   asvetliakov.vscode-neovim
    #   waderyan.gitblame
    #   usernamehw.errorlens
    #   esbenp.prettier-vscode
    # ];
  };
}
