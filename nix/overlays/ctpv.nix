# ctpv (used within lf) is broken on homelab
# See https://github.com/NikitaIvanovV/ctpv/issues/101
final: prev: let
  name = "ctpv";
in {
  ${name} = prev.${name}.overrideAttrs (finalAttrs: prevAttrs: {
    CFLAGS =
      if final.stdenv.isAarch64
      then ["-fsigned-char"]
      else [];

    preFixup = ''
      wrapProgram $out/bin/ctpv \
        --prefix PATH ":" "${
        prev.lib.makeBinPath [
          prev.atool # for archive files
          prev.bat
          prev.chafa # for image files on Wayland
          prev.delta # for diff files
          prev.ffmpeg
          prev.ffmpegthumbnailer
          prev.fontforge
          prev.glow # for markdown files
          prev.imagemagick
          prev.jq # for json files
          prev.poppler-utils # for pdf files
          # prev.ueberzug # for image files on X11
        ]
      }";
    '';

    meta.platforms = with prev.lib; platforms.linux ++ platforms.darwin;
  });
}
