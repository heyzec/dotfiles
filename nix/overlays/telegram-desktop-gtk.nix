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
          cp -r ${pkgs.telegram-desktop}/* $out
          chmod -R +w $out

          wrapProgram $out/bin/Telegram \
            --set QT_QPA_PLATFORMTHEME gtk3

          # Because the .desktop file can activate via dbus, we need to patch that too
          sed -i "s|^Exec=.\+$|Exec=$out/bin/Telegram |" $out/share/dbus-1/services/org.telegram.desktop.service
        '');
      }
    )
  ];
}
