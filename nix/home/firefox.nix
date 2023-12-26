{ config, pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-devedition.override {
      cfg = { enableTridactylNative = true; };
    };

    # Firefox Developer Edition does not allow setting default. Instead, it starts up dev-edition-default
    # https://support.mozilla.org/en-US/kb/understanding-depth-profile-installation#w_firefox-developer-edition_2
    profiles."dev-edition-default" = {
      path = "DualBootProfile";
      userContent = ''
        .wsn-google-focused-link {
          border-left: 3px solid #2586fc !important;
          transform: translate(-3px, 0) !important;
          padding-left: 8px;
          margin-left: -11px;
        }
      '';
      # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      #   ublock-origin
      # ];
    };
  };


  # programs.firefox.profiles."New one" = {
  #   isDefault = true;
  # };

  #   id = 6;
  #   # isRelative = false;
  #   # path = "/media/D/Common AppData/Firefox/profile4";
  #   isDefault = true;
  # };

  home.file."firefox-profile-workaround" = {
    source = config.lib.file.mkOutOfStoreSymlink "/media/D/Common AppData/Firefox/profile4";
    target = ".mozilla/firefox/DualBootProfile";
  };
}
