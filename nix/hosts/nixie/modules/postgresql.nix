{userSettings, ...}: let
  username = userSettings.username;
in {
  heyzec.postgresql = {
    enable = true;
    autoStart = false;
    username = username;
  };
}
