local use_mason = vim.g.heyzec_use_mason

local tooling_utils = require 'heyzec.utils.tooling'
local ensure_installed = tooling_utils.get_ensure_installed()

return {
  {
    -- Provide sensible defaults for LSP servers
    'neovim/nvim-lspconfig',
    -- there is no longer a need to call setup() on nvim-lspconfig
    config = function()
      if not use_mason then
        tooling_utils.setup_servers()
      end
    end,
  },
  {
    -- manage external editor tooling, e.g. LSP servers
    'mason-org/mason.nvim',
    cond = use_mason,
    opts = {},
  },
  {
    -- small integration with nvim-lspconfig to use vim.lsp.enable() servers if installed
    'mason-org/mason-lspconfig.nvim',
    cond = use_mason,
    dependencies = {
      'mason-org/mason.nvim',
      'neovim/nvim-lspconfig',
    },
    ---@module "mason-lspconfig"
    ---@type MasonLspconfigSettings
    opts = {
      ensure_installed = {},
      automatic_enable = true,
    },
  },
  {
    -- declaratively specify tools to automatically install via mason
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    cond = use_mason,
    opts = {
      ensure_installed = ensure_installed,
    },
  },
}
