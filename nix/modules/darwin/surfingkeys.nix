{config, ...}: let
  cfg = config.heyzec.surfingkeys;
in {
  imports = [
    ../shared/surfingkeys.nix
  ];

  launchd = {
    daemons = {
      surfingkeys = {
        command = cfg.command;
        serviceConfig = {
          WorkingDirectory = cfg.cwd;
          KeepAlive = true;
          RunAtLoad = true;
        };
      };
    };
  };
}
