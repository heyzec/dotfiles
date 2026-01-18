-- This must be required before lazy.nvim
-- (plugins like mason, conform need table of config on setup and cannot be delayed)
local setup_tools
if not vim.g.vscode then
  setup_tools = require 'heyzec.tooling'
end

-- Setup lazy.nvim and plugins
-- If NVIM_INIT_DEBUG env var nonempty, debugger will be attached from this point onwards
require 'heyzec.lazy'

-- Trigger callback to continue with setup, as some tool configs have a dependency
-- on plugins loaded by lazy.nvim, e.g. jsonls on schemastore
if setup_tools then
  setup_tools()
end

require 'heyzec.keymaps'
require 'heyzec.autocmds'

-- Flag to enable blink.cmp
vim.g.completion = true

-- Set gutter signs for diagnostics
vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    },
  },
}

-- Show notifications with VS Code's snackbar
if vim.g.vscode then
  vim.notify = require('vscode').notify
end

-- Make escaping terminal mode easier
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
