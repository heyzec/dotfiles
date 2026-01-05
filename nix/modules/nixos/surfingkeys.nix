{config, ...}: let
  cfg = config.heyzec.surfingkeys;
in {
  imports = [
    ../shared/surfingkeys.nix
  ];

  systemd.services.surfingkeys = {
    description = "surfingkeys settings";
    after = ["graphical.target"];
    partOf = ["graphical.target"];
    wantedBy = ["graphical.target"];

    script = cfg.command;
    serviceConfig = {
      WorkingDirectory = cfg.cwd;
    };
  };
}
