{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      asvetliakov.vscode-neovim

      formulahendry.code-runner
      usernamehw.errorlens

      ms-python.python
      ms-python.vscode-pylance
      ms-pyright.pyright
      ms-vscode.cpptools
      golang.go

      ms-vscode.makefile-tools

      yzhang.markdown-all-in-one
      james-yu.latex-workshop
      firefox-devtools.vscode-firefox-debug
    ];
  };
}
