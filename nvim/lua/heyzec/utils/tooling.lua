-- Check if system has Nix package manager
local function has_nix()
  local f = io.open('/nix', 'r')
  if f then
    f:close()
    return true
  end

  return false
end

if vim.g.heyzec_use_mason == nil then
  vim.g.heyzec_use_mason = not has_nix()
end

-- ========== Stateful variables ==========

---@class (partial) vim.lsp.Config.P : vim.lsp.Config
---@type table<string, vim.lsp.Config.P|fun():vim.lsp.Config.P>
---All user-defined LSP servers
local servers = {}

---@type table<string, string[]>
---All user-defined formatters per filetype
local formatters = {}

M = {}

-- ========== Config-facing APIs ==========

---Add an LSP server.
---@param server_name string Name of LSP server (aligned with nvim-lspconfig)
---@param config? vim.lsp.Config.P|fun(nil):vim.lsp.Config.P
M.define_server = function(server_name, config)
  if config == nil then
    config = {}
  end
  servers[server_name] = config
end

---Add a formatter.
---@param ft string Filetype
---@param formatter string Name of formatter
M.define_formatter = function(ft, formatter)
  -- For now only allow one formatter per ft for simplicity
  formatters[ft] = { formatter }
end

-- ========== Tooling-facing APIs ==========

---Setup a single LSP server.
---We don't need to define filetype as this is done automatically by lspconfig.
---@param server_name string Name of LSP server.
M.setup_server = function(server_name)
  ---@type vim.lsp.ClientConfig
  local config
  local server = servers[server_name] or {}
  if type(server) == 'function' then
    config = server()
  else
    config = server
  end
  vim.lsp.config(server_name, config)

  -- If using Mason, mason-lspconfig will automatically setup installed servers
  if not vim.g.heyzec_use_mason then
    vim.lsp.enable(server_name)
  end
end

---Setup all LSP servers as defined by the user.
M.setup_servers = function()
  for k, _ in pairs(servers) do
    M.setup_server(k)
  end
end

---Returns all defined tooling (including LSP servers, formatters) to be installed automatically.
M.get_ensure_installed = function()
  local ensure_installed = {}
  vim.list_extend(ensure_installed, vim.tbl_keys(servers))
  for _, v in pairs(formatters) do
    vim.list_extend(ensure_installed, v)
  end
  return ensure_installed
end

---Returns all defined formatters.
M.get_formatters_config = function()
  return formatters
end

return M
