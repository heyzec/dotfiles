// @ts-ignore
import cssContent from "./theming.css";

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

// ###############################################################################
// ## Theming
// ###############################################################################
settings.theme = cssContent;
