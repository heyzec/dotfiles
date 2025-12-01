// ###############################################################################
// ## Sidebar mappings
// ###############################################################################
const mappings = {
  "chatgpt.com": function () {
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
// api.mapkey(
//   "|",
//   "Sidebar",
//   function () {
//     document
//       .querySelector('span:is([aria-label="left"], [aria-label="right"])')
//       .click();
//   },
//   { domain: /space\.shopee\.io/ },
// );

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

