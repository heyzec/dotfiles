{
  lib,
  pkgs,
  ...
}: let
  # Obtain extension ID from about:support
  extensionsToInstall = [
    "uBlock0@raymondhill.net" # uBlock Origin
    "{ffadac89-63bb-4b04-be90-8cb2aa323171}" # Web Search Navigator
    "{446900e4-71c2-419f-a6a7-df9c091e268b}" # Bitwarden Password Manager
    # Tridactyl: Pin version, see tridactyl#4944
    [
      "tridactyl.vim@cmcaine.co.uk"
      "https://addons.mozilla.org/firefox/downloads/file/4036604/tridactyl_vim-1.23.0.xpi"
    ]
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
    nativeMessagingHosts = [pkgs.tridactyl-native];
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
        userContent = ''
          /* For web-search-navigator extension  */
          /* Add a vertical line instead of an arrow next to selected result */
          /* https://github.com/infokiller/web-search-navigator/issues/427 */
          .wsn-google-focused-link {
              border-left: 3px solid #2586fc !important;
              transform: translate(-3px, 0) !important;
              padding-left: 8px;
              margin-left: -11px;
          }
        '';
        search.engines = {
          "Google".metaData.alias = "@g";

          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
          };
        };
        # Force replacement of config file
        # See https://github.com/nix-community/home-manager/issues/3698
        search.force = true;
      };
    };
  };
}
