local function is_nixos()
  local f = io.open('/etc/os-release', 'r')
  if not f then
    return false
  end

  for line in f:lines() do
    if line == 'ID=nixos' then
      f:close()
      return true
    end
  end

  f:close()
  return false
end

vim.g.heyzec_use_mason = not is_nixos()

-- Extend capabilities, e.g. by blink
-- To figure this out more
-- ChatGPT: If Neovim does not advertise snippetSupport = true, then: LSPs will not send completion items, e.g. for loops
-- TODO: Fix
local capabilities = {}
-- local capabilities = require('blink.cmp').get_lsp_capabilities()
-- Define server-specific configs (capabilities)

--- @module 'vim'
--- @class (partial) vim.lsp.ClientConfig.P : vim.lsp.ClientConfig
--- @type table<string, vim.lsp.ClientConfig.P>
local servers = {}

-- ft to formatter name (predefined list in conform)
local formatters = {}

-- What to do per server?
--- @param server_name string
local setup_server = function(server_name)
  local server = servers[server_name] or {}
  server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
  require('lspconfig')[server_name].setup(server)
end

local setup_servers = function()
  for k, _ in pairs(servers) do
    setup_server(k)
  end
end

local define_lsp = function(server_name, config)
  if config == nil then
    config = {}
  end
  servers[server_name] = config
end

--- @param ft string
--- @param fmts string[]
local define_formatter = function(ft, fmts)
  formatters[ft] = fmts
end

-- mason-tool-installer has no type annoationas. we can best effort it
local get_ensure_installed = function()
  local ensure_installed = {}
  vim.list_extend(ensure_installed, vim.tbl_keys(servers))
  for _, v in pairs(formatters) do
    vim.list_extend(ensure_installed, v)
  end
  return ensure_installed
end

-- TODO: figure out why this annotation doesn't translate to within plugins/formatting.lua
--- @return 1
local get_formatters_config = function()
  return formatters
end

return {
  -- Config-facing APIs
  define_lsp = define_lsp,
  define_formatter = define_formatter,

  -- Tooling-facing APIs
  setup_server = setup_server,
  setup_servers = setup_servers,
  get_formatters_config = get_formatters_config,
  get_ensure_installed = get_ensure_installed,
}
