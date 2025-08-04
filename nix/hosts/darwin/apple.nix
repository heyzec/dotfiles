{
  system.defaults = {
    # Only ask for password if running for longer than 10 seconds
    screensaver.askForPasswordDelay = 10;

    dock = {
      autohide = true;
      # https://apple.stackexchange.com/a/70598
      autohide-delay = 0.0;
      autohide-time-modifier = 0.4;
    };

    WindowManager = {
      EnableStandardClickToShowDesktop = false;
    };

    # defaults write -g ...
    NSGlobalDomain = {
      InitialKeyRepeat = 25;
      KeyRepeat = 3; # Smaller is faster

      # Disable "smart" autocorrect features
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;

      # Disable special character popup
      ApplePressAndHoldEnabled = false;

      # Don't accidentally trigger Look Up feature when pressing harder on trackpad
      "com.apple.trackpad.forceClick" = false;
    };

    # CustomUserPreferences is like an escape hatch, use it only if nix-darwin has no related option
    CustomUserPreferences = {
      # NSGlobalDomain = {};
      # "com.apple.dock" = {};
    };
  }; # system.defaults
}
