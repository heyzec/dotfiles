{
  security = {
    polkit.enable = true;
    pam.services.hyprlock = {};
  };

  programs.hyprlock.enable = true;
}
