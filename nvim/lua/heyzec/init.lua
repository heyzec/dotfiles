-- This must be required before lazy.nvim
-- (plugins like mason, conform need table of config on setup and cannot be delayed)
require 'heyzec.tooling'

-- Setup lazy.nvim and plugins
-- If NVIM_INIT_DEBUG env var nonempty, debugger will be attached from this point onwards
require 'heyzec.lazy'

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
