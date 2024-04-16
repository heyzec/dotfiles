{ systemSettings, ... }:
{
  time.timeZone = systemSettings.timezone;

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
}
