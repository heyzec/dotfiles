// ###############################################################################
// ## Settings
// ###############################################################################
settings.scrollStepSize = 140; // Default is 70

// ###############################################################################
// ## Binds
// ###############################################################################
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
//

const confluence = /confluence\..+\..+/;


// ###############################################################################
// ## Sidebar mappings
// ###############################################################################
const mappings = {
  "chatgpt.com": function() {
    let selector;
    let shouldOpen;
    const hasSlideover = document.querySelector("#stage-slideover-sidebar");
    if (hasSlideover) {
      const width = parseFloat(window.getComputedStyle(hasSlideover).width);
      shouldOpen = width < 100;
    } else {
      const hasPopover = !!document.querySelector("#stage-popover-sidebar");
      shouldOpen = !hasPopover;
    }
    if (shouldOpen) {
      selector = 'button[aria-label="Open sidebar"]';
    } else {
      selector = 'button[aria-label="Close sidebar"]';
    }
    document.querySelector(selector).click();
  },
  "mail.google.com": 'div[aria-label="Main menu"]',
  "git.garena.com": "a.toggle-sidebar-button",
  "space.shopee.io": "div.SIDEBAR_COLLAPSE_BUTTON_CLASSNAME",
};
api.mapkey(
  "|",
  "Sidebar",
  function() {
    document
      .querySelector('span:is([aria-label="left"], [aria-label="right"])')
      .click();
  },
  { domain: /space\.shopee\.io/ },
);
api.mapkey(
  "|",
  "Sidebar",
  function() {
    document
      .querySelector(
        '*:is([aria-label="Hide file browser"], [aria-label="Show file browser"])',
      )
      .click();
  },
  { domain: /git\.garena\.com/ },
);

Object.keys(mappings).forEach((key) => {
  const value = mappings[key];
  const domainRegex = new RegExp(key.replace(/[.]/g, "\\$&"));
  let callback;
  if (typeof value === "function") {
    callback = value;
  } else if (typeof value === "string") {
    callback = () => document.querySelector(value).click();
  }
  api.mapkey("\\", "Sidebar", callback, { domain: domainRegex });
});

// ###############################################################################
// ## Sidebar mappings
// ###############################################################################
//
// api.mapkey(
//   "\\",
//   "Sidebar",
//   function () {
//     const event = new KeyboardEvent("keydown", {
//       key: "[",
//       code: "BracketLeft",
//       keyCode: 219,
//       which: 219,
//       bubbles: true,
//       cancelable: true,
//     });
//
//     document.dispatchEvent(event);
//     api.unmap("[");
//     api.Normal.feedkeys("[");
//     return;
//
//     const url = new URL(window.location.href);
//     if (url.searchParams.has("filter")) {
//       try {
//         const elem = document
//           // .querySelector("span:is(.toggle-filter-panel, .ui-undock)")
//           .querySelector(".toggle-filter-panel");
//         // .querySelector(".ui-undock")
//         // .click();
//         // api.Normal.feedkeys("[");
//       } catch (err) {
//         api.Front.showPopup(err.toString());
//       }
//     } else {
//       document.querySelector("button.aui-sidebar-toggle").click();
//     }
//   },
//   // { domain: jira },
// );
//
// api.mapkey(
//   "\\",
//   "Sidebar",
//   function () {
//     document.querySelector("a.expand-collapse-trigger").click();
//   },
//   { domain: confluence },
// );
//
// api.imapkey("<Meta-s>", "Sidebar", function () {
//   api.Front.showPopup("Hi");
// });

// ###############################################################################
// ## Website-specific customizations
// ###############################################################################
// api.imapkey("<Meta-g>", "Open Issues tab", function () {
//   alert("Hi");
// });

const copyWithoutParameters = function() {
  // Remove query parameters
  const baseUrl = window.location.origin + window.location.pathname;
  api.Clipboard.write(baseUrl);
};
// GitHub

api.mapkey(
  "<Space>c",
  "Open Code tab",
  function() {
    document.querySelector('span[data-content="Code"]').click();
  },
  { domain: /github\.com/ },
);
api.mapkey(
  "<Space>i",
  "Open Issues tab",
  function() {
    document.querySelector('span[data-content="Issues"]').click();
  },
  { domain: /github\.com/ },
);
api.mapkey(
  "<Space>p",
  "Open Pull Requests tab",
  function() {
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


// ###############################################################################
// ## Injects (Poor man's Tampermonkey)
// ###############################################################################
const regex = /confluence\..+\..+/;
const domain = window.location.hostname; // e.g. "confluence.example.com"


// @name        New script shopee.io
// @namespace   Violentmonkey Scripts
// @match       https://confluence.shopee.io/*
// @grant       none
// @version     1.0
// @author      -
// @description 9/10/2025, 5:09:26 PM

// // @match       https://confluence.shopee.io/*

// const css = `
//   .heading-arrow, .heading-arrow-hover {
//     transform: scale(1.7);
//   }
// `;
// const style = document.createElement("style");
// style.textContent = css;
// document.head.appendChild(style);
//
// // Wait for page load
// window.addEventListener("load", () => {
//
//
//   const isCollapsed = !!document.querySelector("ehp-nav-popup");
//   if (isCollapsed) {
//     // alert("Skip because collapsed")
//     return;
//   }
//   const btn = document.getElementById("ehp-navigation-switcher");
// btn.click();
// });

// Disable editing ticket title directly
if (window.location.hostname === "jira.shopee.io") {
  const url = new URL(window.location.href);
  if (
    !url.pathname.startsWith("/browse")
    || url.searchParams.has("filter")
    || url.searchParams.has("jql")
  ) {
    return;
  }
  try {

    document.querySelector("h1 > span").style.visibility = "hidden";
    document.querySelector("#summary-val").style.pointerEvents = "none";
  } catch (err) {
    api.Front.showPopup(`Failed to disable editing title (please modify escape conditions)`);
  }
}

// It's ridicioulous that a dialog for editing code is so small
if (window.location.hostname === "space.shopee.io") {
  if (!window.location.pathname.startsWith("/console/cmdb/config_center")) {
    return;
  }
  if (!window.location.pathname.endsWith("create_pr")) {
    return;
  }
  const style = document.createElement("style");
  document.head.appendChild(style);
  style.textContent = `
div[role="dialog"] {
  transform: none !important;
  margin-left: 5vw;
}

.ant-modal-content {
  width: 90vw !important;
  height: 80vw !important;
}

.ant-modal-body > form > div {
  margin-bottom: 5px;
}

#ace-editor {
  width: 75vw !important;
  height: 50vw !important;
}
`;
}


// TODO: Add this
// // ==UserScript==
// // @name        New script shopee.io
// // @namespace   Violentmonkey Scripts
// // @match       https://confluence.shopee.io/*
// // @grant       none
// // @version     1.0
// // @author      -
// // @description 9/10/2025, 5:09:26 PM
// // ==/UserScript==
// // Inject CSS
// const css = `
//   .heading-arrow, .heading-arrow-hover {
//     transform: scale(1.7);
//   }
// `;
// const style = document.createElement("style");
// style.textContent = css;
// document.head.appendChild(style);
//
// // Wait for page load
// window.addEventListener("load", () => {
//
//
//   const isCollapsed = !!document.querySelector("ehp-nav-popup");
//   if (isCollapsed) {
//     // alert("Skip because collapsed")
//     return;
//   }
//   const btn = document.getElementById("ehp-navigation-switcher");
// btn.click();
// });

// ###############################################################################
// ## Theming
// ###############################################################################
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
.sk_theme .omnibar_folder {
    color: #e5c07b;
}
.sk_theme .omnibar_timestamp {
    visibility: hidden;
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
