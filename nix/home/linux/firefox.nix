{
  lib,
  pkgs,
  config,
  ...
}: let
  # Obtain extension ID from about:support
  extensionsToInstall = [
    "uBlock0@raymondhill.net" # uBlock Origin
    "{ffadac89-63bb-4b04-be90-8cb2aa323171}" # Web Search Navigator
    "{446900e4-71c2-419f-a6a7-df9c091e268b}" # Bitwarden Password Manager
    "{a8332c60-5b6d-41ee-bfc8-e9bb331d34ad}" # Surfingkeys
    "{762f9885-5a13-4abd-9c77-433dcd38b8fd}" # Return YouTube Dislike
    "deArrow@ajay.app" # DeArrow
    "sponsorBlocker@ajay.app" # SponsorBlock for YouTube - Skip Sponsorships
    "rester@kuehle.me" # RESTer
    "extension@tabliss.io" # Tabliss, a nicer new tab page
    "{e9090647-32ff-48e4-9c3c-1361e8fd270e}" # Modern for Wikipedia
  ];

  ublockSettings = let
    # Using a list uploaded online because uBlockSettings.toOverwrite.filters is not working, unsure why
    personalListUrl = "https://gist.githubusercontent.com/heyzec/aab6614c97e937d1a0f57e2bb9c50190/raw/2578c3e2b5da4a34cbaab57347dbfe02fdeb9a8d/annoyances.txt";
  in {
    userSettings = rec {
      importedLists = [personalListUrl];
      externalLists = lib.concatStringsSep "\n" importedLists;
    };
    selectedFilterLists = [
      "user-filters"
      "ublock-filters"
      "ublock-badware"
      "ublock-privacy"
      "ublock-abuse"
      "ublock-unbreak"
      "easylist"
      "easyprivacy"
      "urlhaus-1"
      "plowe-0"
      personalListUrl
    ];
  };
in {
  programs.firefox = {
    enable = true;
    policies = {
      # See https://mozilla.github.io/policy-templates/
      DisableTelemetry = true;

      ### EXTENSIONS ###
      # https://mozilla.github.io/policy-templates/#extensionsettings
      ExtensionSettings = builtins.listToAttrs (map (entry: let
          id =
            if builtins.isString entry
            then entry
            else builtins.elemAt entry 0;
          install_url =
            if builtins.isString entry
            then "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi"
            else builtins.elemAt entry 1;
        in {
          name = id;
          value = {
            inherit install_url;
            installation_mode = "force_installed";
          };
        })
        extensionsToInstall);

      "3rdparty".Extensions = {
        # Schema: https://github.com/gorhill/uBlock/blob/master/platform/common/managed_storage.json
        "uBlock0@raymondhill.net".adminSettings = ublockSettings;
      };

      # Replicate DuckDuckGo bangs
      "SearchEngines" = {
        "Add" = [
          {
            "Name" = "Wikipedia";
            "URLTemplate" = "https://en.wikipedia.org/w/index.php?title=Special:Search&search={searchTerms}";
            "IconURL" = "https://en.wikipedia.org/favicon.ico";
            "Alias" = "!w";
            "SuggestURLTemplate" = "https://en.wikipedia.org/w/api.php?action=opensearch&search={searchTerms}&limit=10&namespace=0&format=json";
          }
          {
            "Name" = "YouTube";
            "URLTemplate" = "https://www.youtube.com/results?search_query={searchTerms}";
            "IconURL" = "https://www.youtube.com/favicon.ico";
            "Alias" = "!yt";
            "SuggestURLTemplate" = "https://suggestqueries.google.com/complete/search?client=firefox&ds=yt&q={searchTerms}";
          }
          {
            "Name" = "Google Maps";
            "URLTemplate" = "https://www.google.com/maps/search/?api=1&query={searchTerms}";
            "IconURL" = "https://www.google.com/images/branding/product/ico/web_maps_icon_32dp.ico";
            "Alias" = "!maps";
          }
          {
            "Name" = "Nix Packages";
            "URLTemplate" = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
            "IconURL" = "https://search.nixos.org/images/nixos-logomark-default-gradient-none.svg";
            "Alias" = "!np";
          }
          {
            "Name" = "Nix Options";
            "URLTemplate" = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
            "IconURL" = "https://search.nixos.org/images/nixos-logomark-default-gradient-none.svg";
            "Alias" = "!no";
          }
          {
            "Name" = "Reddit";
            "URLTemplate" = "https://www.google.com/search?q=site:reddit.com+{searchTerms}";
            "IconURL" = "https://www.reddit.com/favicon.ico";
            "Alias" = "!r";
            "SuggestURLTemplate" = "https://suggestqueries.google.com/complete/search?output=firefox&q=site:reddit.com+{searchTerms}";
          }
          {
            "Name" = "Sourcegraph";
            "URLTemplate" = "https://sourcegraph.com/search?q=context:global+{searchTerms}";
            "IconURL" = "https://sourcegraph.com/favicon.ico";
            "Alias" = "!sg";
          }
          {
            "Name" = "Wikivoyage";
            "URLTemplate" = "https://en.wikivoyage.org/w/index.php?title=Special:Search&search={searchTerms}";
            "IconURL" = "https://en.wikivoyage.org/favicon.ico";
            "Alias" = "!wv";
            "SuggestURLTemplate" = "https://en.wikivoyage.org/w/api.php?action=opensearch&search={searchTerms}&limit=10&namespace=0&format=json";
          }
        ];
      };
    };
    profiles = {
      "default" = {
        name = "Default";
        settings = {
          "browser.aboutConfig.showWarning" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          # See https://www.reddit.com/r/hyprland/comments/1czd5j8/firefox_title_bar_and_tabs_do_not_appear_on/
          # May be fixed in future versions of Firefox
          "browser.fullscreen.autohide" = false;
          "middlemouse.paste" = false;
        };
        # userContent = "/* CSS content */";
        # search.engines = { ... } # replaced with ExtensionSettings policy
      };
    };
    # To silence warning because `home.stateVersion` is less than "26.05"
    configPath = "${config.xdg.configHome}/mozilla/firefox";
  };
}
