-- Extend capabilities, e.g. by blink
-- To figure this out more
-- ChatGPT: If Neovim does not advertise snippetSupport = true, then: LSPs will not send completion items, e.g. for loops
local capabilities = require('blink.cmp').get_lsp_capabilities()
-- Define server-specific configs (capabilities)

--- @module 'vim'
--- @class (partial) vim.lsp.ClientConfig.P : vim.lsp.ClientConfig
--- @type table<string, vim.lsp.ClientConfig.P>
local servers = {
  lua_ls = {
    cmd = { 'hah' },
    capabilities = {},
  },
}

-- ft to formatter name (predefined list in conform)
local formatters = {
  lua = { 'stylua' },
  nix = { 'alejandra' },
  typescriptreact = { 'prettier' },
  -- Conform can also run multiple formatters sequentially
  -- python = { "isort", "black" },
  --
  -- You can use 'stop_after_first' to run the first available formatter from the list
  -- javascript = { "prettierd", "prettier", stop_after_first = true },
}

-- What to do per server?
local lsp_setup = function(server_name)
  local server = servers[server_name] or {}
  server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
  require('lspconfig')[server_name].setup(server)
end

local setup_lsps = function()
  lsp_setup 'lua_ls'
  lsp_setup 'nil_ls'
  lsp_setup 'jsonls'
end

return {
  lsp_setup_handler = lsp_setup,
  setup_lsps = setup_lsps,
  formatters_config = formatters,
}
