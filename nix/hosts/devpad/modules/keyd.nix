{ pkgs, ... }:
{
  # keyd
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ ];
        # My config is added to /etc/keyd/ manually instead of via nix
      };
    };
  };

  # swhkd
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.policykit.exec" &&
            action.lookup("program") == "/run/current-system/sw/bin/swhkd") {
                return polkit.Result.YES;
        }
    });
  '';

  environment.systemPackages = with pkgs; [
    keyd  # Add keyd to programs too for manpage
    swhkd
  ];
}

