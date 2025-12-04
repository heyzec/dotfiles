{
  system.defaults = {
    # Only ask for password if running for longer than 10 seconds
    screensaver.askForPasswordDelay = 10;

    dock = {
      autohide = true;

      # https://apple.stackexchange.com/a/70598
      autohide-delay = 0.0;
      autohide-time-modifier = 0.4;

      # https://nikitabobko.github.io/AeroSpace/guide#a-note-on-mission-control
      expose-group-apps = true;

      # Disable hot corner action for bottom-right (defaults to Quick Note)
      wvous-br-corner = 1;
    };

    WindowManager = {
      # Disable click wallpaper to reveal desktop
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

    ".GlobalPreferences" = {
      "com.apple.mouse.scaling" = 1.0; # the setting of this value seems glitchy
    };

    # CustomUserPreferences is like an escape hatch, use it only if nix-darwin has no related option
    CustomUserPreferences = {
      # NSGlobalDomain = {};
      # See https://apple.stackexchange.com/questions/365048/disable-dictation-from-command-line
      "com.apple.HIToolbox" = {
        AppleDictationAutoEnable = false;
      };
    };
  }; # system.defaults

  security.pam.services.sudo_local = {
    touchIdAuth = true; # Use Touch ID for sudo in terminals
    reattach = true; # Fixes Touch ID not working inside tmux
  };
}
