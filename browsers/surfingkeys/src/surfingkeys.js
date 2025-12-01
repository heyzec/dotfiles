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
const jira = /jira\..+\..+/;

// api.mapkey(
//   "<Space>b",
//   "Branch",
//   function () {
//     const issueKey = window.location.pathname.split("/").pop();
//     const issueNameFull = Array.from(
//       document.querySelector("#summary-val").childNodes,
//     )
//       .filter((node) => node.nodeType === Node.TEXT_NODE) // text nodes only
//       .map((node) => node.textContent)
//       .join("")
//       .trim();
//
//     const issueName = issueNameFull.split("|")[2].trim();
//     const issueNameSnakeCase = issueName.toLowerCase().replace(/\s+/g, "_");
//     const branchName = `huizheng.tiang/feature/${issueKey}-${issueNameSnakeCase}`;
//     api.Clipboard.write(branchName);
//   },
//   { domain: jira },
// );
//
// api.mapkey(
//   "<Space>k",
//   "Branch",
//   function () {
//     const issueKey = window.location.pathname.split("/").pop();
//     api.Clipboard.write(issueKey);
//   },
//   { domain: jira },
// );

import "./injects.js";
import "./theming.js";
import "./sidebar.js";
import "./yanking.js";

