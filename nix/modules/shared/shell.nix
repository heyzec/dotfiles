{
  lib,
  pkgs,
  config,
  ...
}: {
  options = {
    heyzec.shell = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable zsh with useful tools for a CLI workflow";
      };
      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
      };
    };
  };

  config = let
    ifLinux = pkg:
      if pkgs.stdenv.isLinux
      then pkg
      else null;

    # Refer to https://wiki.archlinux.org/title/List_of_applications
    # A: Documents
    # B: Internet
    # C: Multimedia
    # D: Science
    # E: Security
    # F: Utilities
    # G: Other
    # and https://wiki.archlinux.org/title/Core_utilities (S)
    packages = with pkgs;
      lib.lists.remove null [
        ##### Needed by dotfiles #####
        ##### .zshrc #####
        ripgrep #  # (S.3.8.1) grep alternative (code searcher)
        fzf #      # (S.3.8.2) grep alternative (interactive filter)
        bat #      # (S.3.1) cat alternative
        zoxide #   # (S.3.2) cd alternative
        eza #      # (S.3.5) ls alternative
        bat-extras.batman
        file #     # needed by lf
        ##### lf #####
        starship # # shell prompt customization
        ##### git #####
        diffr #    # (F.2.5.1) word-level diff highlighter

        ##### Network #####
        wget # (B.4.1.1) download files
        nmap # (E.1) port scanner
        dig # (Domain_name_resolution#Lookup_utilities) check DNS entries
        (ifLinux traceroute) # (Network_tools#Traceroute) track route taken by packets

        ##### Shell utilities #####
        tmux #         # (F.1.4) terminal multiplexer
        lf #           # (F.2.1.1) terminal file manager
        zip #          # (F.2.4.1) archiving (Info-Zip)
        unzip #        # (F.2.4.1) more archiving (Info-Zip)
        xxd #          # (F.3.10) hex dump
        (ifLinux ctpv) # file previewer for lf, with image support
        (ifLinux psmisc) # utilities that use /proc, e.g. pstree (note1)

        ##### Development #####
        git #   # (F.3.2) the information manager from hell
        jq #    # (F.3.12) JSON processor
        lazygit # (Git#Graphical_front-ends) TUI for git
        just #  # Makefile alternative to save project-specific commands
        pet #   # CLI snippet manager
      ];
    # note1: don't use `pstree` package on nixpkgs,
    # it seems to fail for process on running on other ttys, e.g. tmux
  in {
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;

    heyzec.shell.packages = packages;
  };
}
