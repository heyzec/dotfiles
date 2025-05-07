-- vim.g.heyzec_use_mason = false
require 'heyzec.tooling'

-- Think about the dependencies. heyzec.utils.lsp, lazy plugins (mason, formatter)
-- Mason will call lsp-config handler for installed LSPs. This seems to be a must
-- So, we need to setup our stuff before lazy

-- Setup lazy.nvim and plugins
require 'heyzec.lazy'

require 'heyzec.keymaps'
require 'heyzec.autocmds'

-- set gutter signs for diagnostics
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
