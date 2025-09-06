{pkgs, ...}: {
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

  # swkhd
  systemd.services.swhkd = {
    description = "swhkd hotkey daemon";
    after = ["graphical.target"];
    partOf = ["graphical.target"];
    wantedBy = ["graphical.target"];

    environment = {
      XDG_RUNTIME_DIR = "/run/user/1000"; # hacky
    };
    path = [];

    script = ''
      ${pkgs.swhkd}/bin/swhkd
    '';
  };

  environment.systemPackages = with pkgs; [
    keyd # Add keyd to programs too for manpage
    swhkd
  ];
}
