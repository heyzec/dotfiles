{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    # Whether extensions can be modified by Visual Studio Code
    mutableExtensionsDir = true;

    extensions = with pkgs.vscode-extensions; [
      asvetliakov.vscode-neovim
      waderyan.gitblame
      usernamehw.errorlens
      esbenp.prettier-vscode
    ];
  };
}
