{ pkgs, config, ... }:
{
  services.nix-daemon.enable = true;
  nixpkgs.hostPlatform = "x86_64-darwin";

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;
  networking.hostName = "darwin";

  environment.systemPackages = with pkgs; [
    alacritty
    (nh.overrideAttrs (prev: rec {
      src = fetchFromGitHub {
        owner = "ToyVo";
        repo = "nh";
        rev = "aa4bc963cbbdc44d0ed35d18345c911d465a5c7e";
        hash = "sha256-yX0NOCmiRq3iMAwsKoSMxhfBMkLlZirHdmAyZIL95FM=";
      };
      cargoDeps = prev.cargoDeps.overrideAttrs (_: {
        inherit src;
        outputHash = "sha256-eejh7hTUZUIP1sitXXfxTwGfeaPIo73KDgzTDlFS/Vg=";
      });
        preFixup = ''
          mkdir completions
          $out/bin/nh_darwin completions --shell bash > completions/nh_darwin.bash
          $out/bin/nh_darwin completions --shell zsh > completions/nh_darwin.zsh
          $out/bin/nh_darwin completions --shell fish > completions/nh_darwin.fish

          installShellCompletion completions/*
        '';

        postFixup = let
          runtimeDeps = [ nvd nix-output-monitor ];
        in ''
          wrapProgram $out/bin/nh_darwin \
            --prefix PATH : ${lib.makeBinPath runtimeDeps}
        '';
    }))
  ];

  # Enable sudo auth with Touch ID, e.g. in terminal
  security.pam.enableSudoTouchIdAuth = true;

  system.activationScripts.postUserActivation.text = ''
    # Fix to automatically add applications to launchers
    # https://github.com/LnL7/nix-darwin/issues/214#issuecomment-2050027696
    rsyncArgs="--archive --checksum --chmod=-w --copy-unsafe-links --delete"
    apps_source="${config.system.build.applications}/Applications"
    moniker="Nix Trampolines"
    app_target_base="$HOME/Applications"
    app_target="$app_target_base/$moniker"
    mkdir -p "$app_target"
    ${pkgs.rsync}/bin/rsync $rsyncArgs "$apps_source/" "$app_target"

    # Following line should allow us to avoid a logout/login cycle
    # https://medium.com/@zmre/nix-darwin-quick-tip-activate-your-preferences-f69942a93236
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
