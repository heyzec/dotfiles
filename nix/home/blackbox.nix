{ lib, ... }:
{
  # APPLICATION SPECIFIC CONFIGS
  dconf.settings = {
      "com/raggesilver/BlackBox" = { 
        "show-headerbar" = false;
        "opacity" = lib.hm.gvariant.mkUint32 50;
        "theme-dark" = "Modified Tango";
        "use-sixel" = true;
        "font" = "Monospace 11";
      };
  };
}
