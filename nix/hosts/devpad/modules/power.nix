{
  heyzec.power = {
    enable = false;

    blankAfter = 10 * 60; # 10 minutes
    sleepAfter = 15 * 60; # 15 minutes
    hibernateAfter = 1 * 60 * 60; # 1 hour

    commandBlankScreen = "hyprctl dispatch dpms off";
    commandUnblankScreen = "hyprctl dispatch dpms on";
    commandLockScreen = "hyprlock";
  };
}
