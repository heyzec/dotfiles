{ lib, pkgs, ... }:
{
  programs = {
    neovim = {
      package = pkgs.neovim-unwrapped.overrideAttrs (finalAttrs: previousAttrs: {
        nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [ pkgs.makeWrapper ];
        postFixUp = ''
          wrapProgram $out/bin/nvim \
            --prefix PATH : ${lib.makeBinPath [ pkgs.cargo ]}
          exit 1
        '';
      });


      enable = true;
      defaultEditor = true;

      # For mason to install LSPs using npm
      withNodeJs = true;

      # Configure vimrc using non-nix config file
      # configure = {};
    };
  };


  environment.systemPackages = with pkgs; [
    shellcheck
    nodePackages.bash-language-server
  ];
}

