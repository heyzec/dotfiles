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
          KeepAlive = true;
          RunAtLoad = true;
        };
      };
    };
  };
}
