{
  # Keyboard
  services.karabiner-elements.enable = true;

  # Mouse
  homebrew = {
    casks = [
      "unnaturalscrollwheels" # Enable natural scrolling in the trackpad but regular scroll on an external mouse
    ];
  };
  system.defaults = {
    CustomUserPreferences = {
      "com.theron.UnnaturalScrollWheels" = {
        LaunchAtLogin = true;
      };
    };
  };
}
