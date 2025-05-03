-- vim.g.heyzec_use_mason = false
require 'heyzec.tooling'

-- Think about the dependencies. heyzec.utils.lsp, lazy plugins (mason, formatter)
-- Mason will call lsp-config handler for installed LSPs. This seems to be a must
-- So, we need to setup our stuff before lazy

require 'heyzec.lazy'

---@diagnostic disable-next-line: undefined-global
if init_debug then
  require('osv').launch { port = 8086, blocking = true }
  vim.cmd.sleep(1) -- without this, breakpoints seem to be not registered fast enough
end

require 'heyzec.keymaps'
require 'heyzec.autocmds'

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
