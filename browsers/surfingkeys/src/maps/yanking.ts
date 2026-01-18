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
