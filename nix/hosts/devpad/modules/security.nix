{
  security = {
    polkit.enable = true;
    pam.services.hyprlock = {};

    sudo.extraConfig = ''
      Defaults pwfeedback
    '';
  };

  programs.hyprlock.enable = true;
}
