{ config, ... }:
{
  # services.udiskie = {
  #   enable = true;
  # };


  services.mako = {
    enable = true;
    defaultTimeout = 10000;
    backgroundColor = "#${config.colorScheme.palette.base01}";
    borderColor = "#${config.colorScheme.palette.base0E}";
    textColor = "#${config.colorScheme.palette.base04}";
    borderRadius = 5;
    borderSize = 2;
  };
}

