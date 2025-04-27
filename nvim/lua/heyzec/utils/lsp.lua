-- Extend capabilities, e.g. by blink
-- To figure this out more
-- ChatGPT: If Neovim does not advertise snippetSupport = true, then: LSPs will not send completion items, e.g. for loops
local capabilities = require('blink.cmp').get_lsp_capabilities()
-- Define server-specific configs (capabilities)
local servers = {
  lua_ls = {},
}

-- What to do per server?
return function(server_name)
  local server = servers[server_name] or {}
  server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
  require('lspconfig')[server_name].setup(server)
end
