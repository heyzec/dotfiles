local M = {}


        -- local lspconfig = require('lspconfig')
        -- -- See https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
        -- lspconfig.nil_ls.setup {
        --     settings = {
        --         ['nil'] = {
        --             formatting = {
        --                 command = { "nixpkgs-fmt" },
        --             }
        --         }
        --
        --     }
        -- }
-- Define configs for each specific language here
M.servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
        -- Stop prompting
        -- See https://github.com/LunarVim/LunarVim/issues/4049
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- to enable autocompletion (assign to every lsp server config)
M.capabilities = vim.lsp.protocol.make_client_capabilities()

return M

