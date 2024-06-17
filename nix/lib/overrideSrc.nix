{
  name,
  src ? null,
  patches ? []
}:
{
  nixpkgs.overlays = [
    (final: prev:
      {
        ${name} = (prev.${name}.overrideAttrs (finalAttrs: prevAttrs: {
          src = if src != null then src else prevAttrs.src;
          patches = (prevAttrs.patches or []) ++ patches;
        }));
      }
    )
  ];
}

