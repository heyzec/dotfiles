{
  system.defaults = {
    # Only ask for password if running for longer than 10 seconds
    screensaver.askForPasswordDelay = 10;

    NSGlobalDomain = {
      InitialKeyRepeat = 25;
      KeyRepeat = 3;  # Smaller is faster

      # Disable "smart" autocorrect features
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
    };

    CustomUserPreferences = {
      "com.apple.dock" = {
        autohide = true;
        # https://apple.stackexchange.com/a/70598
        autohide-delay = 0;
        autohide-time-modifier = 0.4;
      };
    };
  };
}
