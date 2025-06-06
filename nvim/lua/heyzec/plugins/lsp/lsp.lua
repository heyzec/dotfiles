local tooling_utils = require 'heyzec.utils.tooling'
local use_mason = vim.g.heyzec_use_mason

-- TODO: Eventually update to use mason v2, which is a breaking change
local mason_dependencies = {
  -- manage external editor tooling, e.g. LSP servers
  { 'mason-org/mason.nvim', cond = use_mason, version = '^1.0.0' },
  -- better mason and lsp-config integration
  { 'mason-org/mason-lspconfig.nvim', cond = use_mason, version = '^1.0.0' },
  -- declaratively specify tools to automatically install via mason
  { 'WhoIsSethDaniel/mason-tool-installer.nvim', cond = use_mason },
}

return {
  -- Provide sensible defaults for LSP servers
  'neovim/nvim-lspconfig',
  dependencies = {
    mason_dependencies,
  },
  config = function()
    if not use_mason then
      tooling_utils.setup_servers()
      return
    end

    local ensure_installed = tooling_utils.get_ensure_installed()
    -- mason must be loaded before its dependents so we need to set it up here
    require('mason').setup {}
    -- install tools if not already installed
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }
    -- setup mason-lspconfig to use configure servers if installed
    require('mason-lspconfig').setup {
      ensure_installed = {},
      automatic_installation = false,
      handlers = { tooling_utils.setup_server },
    }
  end,
}
