{
  systemSettings,
  lib,
  ...
}: {
  imports =
    if (lib.strings.hasSuffix "darwin" systemSettings.system)
    then
      (lib.heyzec.umport {
        path = ./.;
      })
    else [];
}
