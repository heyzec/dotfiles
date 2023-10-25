{ config, ... }:
{
  # services.udiskie = {
  #   enable = true;
  # };

  # services.gpg-agent = {
  #   enable = true;
  #   enableSshSupport = true;
  #   defaultCacheTtl = 1800;
  # };

  services.mako = {
    enable = true;
    defaultTimeout = 10000;
    backgroundColor = "#${config.colorScheme.colors.base01}";
    borderColor = "#${config.colorScheme.colors.base0E}";
    textColor = "#${config.colorScheme.colors.base04}";
    borderRadius = 5;
    borderSize = 2;
  };
}

