{
  # ---- SYSTEM SETTINGS ---- #
  systemSettings = {
    system = "x86_64-linux"; # system arch
    hostname = "devpad";
    timezone = "Asia/Singapore";
    locale = "en_SG.UTF-8";
    isHome = false;
  };

  # ----- USER SETTINGS ----- #
  userSettings = rec {
    username = "heyzec";
    homeDir = "/home/${username}";
    dotfilesDir = "~/dotfiles"; # path to dotfiles repo, used by vm (good to start with ~)
    flakeDir = "/home/heyzec/dotfiles"; # path to flake repo, used by nh
  };

  # ----- Override SYSTEM and USER SETTINGS on a per-host basis here ----- #
  specificSettings = {
    "homelab" = {
      systemSettings.system = "aarch64-linux";
    };
    "darwin" = {
      systemSettings.system = "aarch64-darwin";
    };
    "darwin-home" = {
      systemSettings.system = "aarch64-darwin";
      userSettings.homeDir = "/Users/SP15013";
      userSettings.username = "SP15013";
    };
  };
}
