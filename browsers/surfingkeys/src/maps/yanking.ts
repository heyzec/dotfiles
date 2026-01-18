// ###############################################################################
// ## Website-specific customizations
// ###############################################################################

const copyWithoutParameters = function () {
  // Remove query parameters
  const baseUrl = window.location.origin + window.location.pathname;
  api.Clipboard.write(baseUrl);
};
// Wikipedia
api.mapkey("yy", "Copy link (Wikipedia)", copyWithoutParameters, {
  domain: /en\.wikipedia\.org/,
});
// TikTok
api.mapkey("yy", "Copy link (TikTok)", copyWithoutParameters, {
  domain: /www\.tiktok\.com/,
});

// Confluence
api.mapkey(
  "yy",
  "Copy link (Confluence)",
  function () {
    // Use shortlink instead (which is a permalink)
    const link = document.querySelector('link[rel="shortlink"]').href;
    api.Clipboard.write(link);
  },
  { domain: /confluence\..+\..+/ },
);

// Google Maps coordinates reversed engineered
api.mapkey(
  "yy",
  "Copy link (Google Maps)",
  () => {
    if (!window.location.href.startsWith("https://www.google.com/maps/place")) {
      console.log("Not a place URL");
      return;
    }
    const script = document.head.querySelector("script:not([src])");
    let text = script.textContent;
    let match = text.match(/window\.ES5DGURL='(.+?)data/);
    text = match[1];
    match = text.match(/\/maps\/place\/(.+?)\/@([\d.]+,[\d.]+),.+?\//);
    coords = match[2];
    api.Clipboard.write(coords);
  },
  {
    domain: /www\.google\.com/,
  },
);
