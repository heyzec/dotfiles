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

-- -- The following two autocommands are used to highlight references of the
-- -- word under your cursor when your cursor rests there for a little while.
-- --    See `:help CursorHold` for information about when this is executed
-- --
-- -- When you move your cursor, the highlights will be cleared (the second autocommand).
-- local client = vim.lsp.get_client_by_id(event.data.client_id)
-- if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
--   local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
--   vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
--     buffer = event.buf,
--     group = highlight_augroup,
--     callback = vim.lsp.buf.document_highlight,
--   })
--
--   vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
--     buffer = event.buf,
--     group = highlight_augroup,
--     callback = vim.lsp.buf.clear_references,
--   })
--
--   vim.api.nvim_create_autocmd('LspDetach', {
--     group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
--     callback = function(event2)
--       vim.lsp.buf.clear_references()
--       vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
--     end,
--   })
-- end
