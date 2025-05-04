local tooling_utils = require 'heyzec.utils.tooling'
local use_mason = vim.g.heyzec_use_mason

local mason_dependencies = {}
if use_mason then
  mason_dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    -- Automatically install LSPs and related tools to stdpath for Neovim
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  }
end

return {
  -- We've determined this brace is needed for `vim` to be defined and more
  -- But is this the place to go?
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  -- Useful status updates for LSP.
  { 'j-hui/fidget.nvim', opts = {} },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      mason_dependencies,

      -- 'saghen/blink.cmp', -- should this be here?
    },
    config = function()
      if not use_mason then
        tooling_utils.setup_servers()
        return
      end

      -- Kickstart defines this from servers table
      local ensure_installed = tooling_utils.get_ensure_installed()
      -- Mason must be loaded before its dependents so we need to set it up here.
      require('mason').setup {}
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      -- I think this is to tell Mason to setup lsp when they are installed
      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          tooling_utils.setup_server,
        },
      }
    end,
  },
}
