{
  userSettings,
  pkgs,
  ...
}: let
  username = userSettings.username;
in {
  heyzec.postgresql = {
    enable = true;
    autoStart = false;
    username = username;
  };
  services.postgresql.extensions = with pkgs.postgresqlPackages; [
    postgis
  ];
  environment.systemPackages = [
    pkgs.qgis
  ];
}
