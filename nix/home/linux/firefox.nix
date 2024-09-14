{ lib, pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = let
      config = {
        extraPolicies = {
          DisableTelemetry = true;
          /* ---- EXTENSIONS ---- */
          ExtensionSettings = {
            # "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
            # uBlock Origin:
            "uBlock0@raymondhill.net" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              installation_mode = "allowed";
            };
          };
          "3rdparty".Extensions = {
            # Schema: https://github.com/gorhill/uBlock/blob/master/platform/common/managed_storage.json
            "uBlock0@raymondhill.net".adminSettings = let
              personalListUrl = "https://gist.githubusercontent.com/heyzec/aab6614c97e937d1a0f57e2bb9c50190/raw/2578c3e2b5da4a34cbaab57347dbfe02fdeb9a8d/annoyances.txt";
            in {
              userSettings = rec {
                importedLists = [ personalListUrl ];
                externalLists = lib.concatStringsSep "\n" importedLists;
              };
              # This is not working
              toOverwrite = {
                filters = [ "a" "b" ];
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
          };
          /* ---- PREFERENCES ---- */
          # Check about:config for options.
          Preferences = {
            "middlemouse.paste" = { Value = false; Status = "locked";};
          };
        };
      };
    in (pkgs.wrapFirefox pkgs.firefox-unwrapped config).override {
      cfg = { enableTridactylNative = true; };
    };
  };
}

