# See https://rycee.gitlab.io/home-manager/options.html
{ pkgs, ... }:
{
  # We're using the "Standalone installation" option, let home-manager install itself
  programs.home-manager.enable = true;

  home.stateVersion = "23.05";
  home.username = "heyzec";
  home.homeDirectory = "/home/heyzec";

  # https://github.com/nix-community/home-manager/issues/1011
  # Does not work
  # home.sessionVariables = {
  #   XDG_CURRENT_DESKTOP = "Hyprland";
  #   XDG_SESSION_DESKTOP="Hyprland";
  #   XDG_SESSION_TYPE="wayland";
  #   TERMINAL = "foot";
  # };
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
    programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

  };
}

# TODO: fix swhkd not starting, we need it for vm
# pylance (vscode’s extension for Python) vs pyright (standard LSP for Python),
