{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev:
      {
        # Let telegram use GTK3, the default QT filepicker is much uglier than the GTK filepicker
        # Fix this by setting the env var QT_QPA_PLATFORMTHEME=gtk3
        # https://github.com/telegramdesktop/tdesktop/issues/2411#issuecomment-636631465
        "telegram-desktop-gtk" = (pkgs.runCommand "Telegram" {
          buildInputs = [ pkgs.makeWrapper ];
        } ''
          mkdir $out
          ln -s ${pkgs.telegram-desktop}/* $out
          rm $out/bin
          mkdir $out/bin
          makeWrapper ${pkgs.telegram-desktop}/bin/Telegram $out/bin/Telegram \
            --set QT_QPA_PLATFORMTHEME gtk3
        '');
      }
    )
  ];
}
