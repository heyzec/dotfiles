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
  });
}
