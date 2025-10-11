-- See here for list of LSP servers with default configs by nvim-lspconfig:
--   https://github.com/neovim/nvim-lspconfig/tree/master/lsp
-- See here for list of formatters supported by Conform:
--   https://github.com/stevearc/conform.nvim#formatters
-- These tools need to be made available in the PATH,
--   possibly by editing nix/modules/neovim.nix

-- Mason is disabled for NixOS systems, set to true/false to override
vim.g.heyzec_use_mason = nil

local tooling_utils = require 'heyzec.utils.tooling'
local define_server = tooling_utils.define_server
local define_formatter = tooling_utils.define_formatter

-- Lua
define_server 'lua_ls'
define_formatter('lua', 'stylua')

-- Nix
if vim.g.heyzec_use_mason then
  -- mason doesn't have nixd yet
  -- https://github.com/mason-org/mason.nvim/issues/1570
  define_server 'nil_ls'
else
  define_server('nixd', {
    settings = {
      nixd = {
        -- Not sure why I need to override to remove default nixpkgs definition.
        -- This is so that we don't have duplication definition goto for NixOS options.
        nixpkgs = {},
        options = {
          nixos = {
            expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.devpad.options',
          },
          home_manager = {
            expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations.heyzec.options',
          },
        },
      },
    },
  })
end
define_formatter('nix', 'alejandra')

-- Config files
-- from hrsh7th/vscode-langservers-extracted
define_server('jsonls', function()
  return {
    settings = {
      json = {
        schemas = require('schemastore').json.schemas {},
        validate = { enable = true },
      },
    },
  }
end)
-- yaml-language-server
define_server('yamlls', function()
  return {
    settings = {
      yaml = {
        schemaStore = {
          -- You must disable built-in schemaStore support if you want to use
          -- this plugin and its advanced options like `ignore`.
          enable = false,
          -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
          url = '',
        },
        schemas = require('schemastore').yaml.schemas(),
      },
    },
  }
end)

-- C++
define_server 'clangd'
define_formatter('cpp', 'clang-format')

-- JavaScript / TypeScript
-- typescript-language-server is an LSP wrapper around Microsoft's tsserver
-- nvim-lspconfig aliases typescript-language-server to ts_ls
define_server 'ts_ls'
define_formatter('javascript', 'prettier')
define_formatter('javascriptreact', 'prettier')
define_formatter('typescript', 'prettier')
define_formatter('typescriptreact', 'prettier')

-- Go
define_server 'gopls'
define_formatter('go', 'goimports')

-- Callback to be invoked after lazy.nvim setup
return function()
  tooling_utils.setup_servers()
end
