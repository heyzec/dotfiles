-- Check if system is using NixOS
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

--- @class (partial) vim.lsp.ClientConfig.P : vim.lsp.ClientConfig
--- @type table<string, vim.lsp.ClientConfig.P>
--- All user-defined LSP servers
local servers = {}

--- @type table<string, string[]>
--- All user-defined formatters per filetype
local formatters = {}

M = {}

-- ========== Config-facing APIs ==========

--- Add an LSP server.
M.define_server = function(server_name, config)
  if config == nil then
    config = {}
  end
  servers[server_name] = config
end

--- Add a formatter.
--- @param ft string Filetype
--- @param formatter string Name of formatter
M.define_formatter = function(ft, formatter)
  -- For now only allow one formatter per ft for simplicity
  formatters[ft] = { formatter }
end

-- ========== Tooling-facing APIs ==========

--- Setup a single LSP server.
--- We don't need to define filetype as this is done automatically by lspconfig.
--- Wrapper of lspconfig.setup (which is in turn a wrapper of vim.lsp.start).
--- @param server_name string Name of LSP server.
M.setup_server = function(server_name)
  -- Extend capabilities, e.g. by blink
  local extra_capabilities = require('blink.cmp').get_lsp_capabilities()
  local server = servers[server_name] or {}
  server.capabilities = vim.tbl_deep_extend('force', {}, extra_capabilities, server.capabilities or {})
  require('lspconfig')[server_name].setup(server)
end

--- Setup all LSP servers as defined by the user.
M.setup_servers = function()
  for k, _ in pairs(servers) do
    M.setup_server(k)
  end
end

--- Returns all defined tooling (including LSP servers, formatters) to be installed automatically.
M.get_ensure_installed = function()
  local ensure_installed = {}
  vim.list_extend(ensure_installed, vim.tbl_keys(servers))
  for _, v in pairs(formatters) do
    vim.list_extend(ensure_installed, v)
  end
  return ensure_installed
end

--- Returns all defined formatters.
M.get_formatters_config = function()
  return formatters
end

return M
