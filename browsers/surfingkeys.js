settings.scrollStepSize = 140; // Default is 70
// ----------------------------Binds----------------------------
// Use H/L to go back/forward in history, just like in Tridactyl/Vimium
api.map("L", "D");
api.map("H", "S");

api.map("<Shift-Esc>", "<Alt-s>"); // Alt to pause surfingkeys is tricky

// Too easily to accidentally close browser
api.unmap("ZZ");
api.unmap("ZQ");

api.iunmap("<Ctrl-a>"); // Restore select all

api.aceVimMap("jk", "<Esc>", "insert");
api.aceVimMap("ZZ", ":wq", "normal");
api.aceVimMap("ZQ", ":q!", "normal");

// Disable for Web Search Navigator
api.unmap("j", /www\.google\.com/);
api.unmap("k", /www\.google\.com/);
api.unmap("j", /github\.com\/.+\/.+\/tree/);
api.unmap("k", /github\.com\/.+\/.+\/tree/);

// const base = window.location.href.split("/").slice(0, 5).join("/");
// const url = base + "/issues";
// api.Front.showPopup(url);
// api.openLink(url);
// api.Front.showPopup("Hello");

// -----------------------Website-specific----------------------
const copyWithoutParameters = function () {
  // Remove query parameters
  const baseUrl = window.location.origin + window.location.pathname;
  api.Clipboard.write(baseUrl);
};
// GitHub
api.mapkey(
  "<Space>c",
  "Open Code tab",
  function () {
    document.querySelector('span[data-content="Code"]').click();
  },
  { domain: /github\.com/ },
);
api.mapkey(
  "<Space>i",
  "Open Issues tab",
  function () {
    document.querySelector('span[data-content="Issues"]').click();
  },
  { domain: /github\.com/ },
);
api.mapkey(
  "<Space>p",
  "Open Pull Requests tab",
  function () {
    document.querySelector('span[data-content="Pull requests"]').click();
  },
  { domain: /github\.com/ },
);

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

// ---------------------------Themeing--------------------------
settings.theme = `
.sk_theme {
    font-family: Input Sans Condensed, Charcoal, sans-serif;
    font-size: 10pt;
    background: #24272e;
    color: #abb2bf;
}
.sk_theme tbody {
    color: #fff;
}
.sk_theme input {
    color: #d0d0d0;
}
.sk_theme .url {
    color: #61afef;
}
.sk_theme .annotation {
    color: #56b6c2;
}
.sk_theme .omnibar_highlight {
    color: #528bff;
}
.sk_theme .omnibar_timestamp {
    color: #e5c07b;
}
.sk_theme .omnibar_visitcount {
    color: #98c379;
}
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
    background: #303030;
}
.sk_theme #sk_omnibarSearchResult ul li.focused {
    background: #3e4452;
}
#sk_status, #sk_find {
    font-size: 20pt;
}`;
