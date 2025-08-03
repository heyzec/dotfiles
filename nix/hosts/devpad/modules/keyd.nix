{
  pkgs,
  userSettings,
  ...
}: {
  # keyd
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [];
        # My config is added to /etc/keyd/ manually instead of via nix
      };
    };
  };

  # swhkd

  # swhkd, the shortcut mapper
  systemd.user.services.swhkd = let
    # Adopted from https://github.com/waycrate/swhkd/tree/main/contrib/init/systemd
    hotkeys = pkgs.writeShellScript "hotkeys.sh" ''
      # ${pkgs.psmisc}/bin/killall swhks 2>/dev/null || true
      # ${pkgs.swhkd}/bin/swhks & # This line doesn't work for unknown reasons, we run it from compositor
      /run/wrappers/bin/pkexec /run/current-system/sw/bin/swhkd -c "/home/${userSettings.username}/.config/swhkd/swhkdrc" --device 'keyd virtual keyboard' --device 'RDMCTMZT ZUOYA GMK67 V2' --device 'RDMCTMZT ZUOYA GMK67 V2 Consumer Control'
    '';
  in {
    description = "swhkd hotkey daemon";
    after = ["graphical-session.target"];
    partOf = ["graphical-session.target"];

    environment = {};
    path = [];
    serviceConfig = {
      UnsetEnvironment = ["XDG_CACHE_HOME"];
    };

    script = "${hotkeys}";
    preStop = ''
      # ${pkgs.psmisc}/bin/killall swhks || true
      /run/wrappers/bin/sudo ${pkgs.psmisc}/bin/killall swhkd
    '';

    wantedBy = ["graphical-session.target"];
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.policykit.exec" &&
            action.lookup("program") == "/run/current-system/sw/bin/swhkd") {
                return polkit.Result.YES;
        }
    });
  '';

  security.sudo = {
    extraRules = [
      {
        commands = [
          {
            command = "${pkgs.psmisc}/bin/killall swhkd";
            options = ["NOPASSWD"];
          }
        ];
        groups = ["wheel"];
      }
    ];
  };

  environment.systemPackages = with pkgs; [
    keyd # Add keyd to programs too for manpage
    swhkd
  ];
}
