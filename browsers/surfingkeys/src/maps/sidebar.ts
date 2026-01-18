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
};

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
