-- Mason is disabled for NixOS systems, set to true/false to override
vim.g.heyzec_use_mason = nil

local lsp_utils = require 'heyzec.utils.tooling'
local define_server = lsp_utils.define_server
local define_formatter = lsp_utils.define_formatter

-- See here for list of formatters supported by Conform:
-- https://github.com/stevearc/conform.nvim#formatters

-- These tools need to be made available in the PATH
-- Possibly by editing nix/modules/neovim.nix

-- Lua
define_server 'lua_ls'
define_formatter('lua', 'stylua')

-- Nix
-- define_server 'nil_ls'
define_server('nixd', {
  settings = {
    nixd = {
      -- Not sure why I need to override to remove default nxipkgs definition. This is so that
      -- This is so that we don't have duplication definition goto for NixOS options.
      nixpkgs = {},
      options = {
        nixos = {
          expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.devpad.options',
        },
        home_manager = {
          expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."heyzec".options',
        },
      },
    },
  },
})
define_formatter('nix', 'alejandra')

-- C++
define_server 'clangd'
define_formatter('cpp', 'clang_format')

-- JavaScript / TypeScript
-- typescript-language-server is an LSP wrapper around Microsoft's tsserver
-- nvim-lspconfig aliases typescript-language-server to ts_ls
define_server 'ts_ls'
define_server 'eslint'
define_formatter('javascript', 'prettier')
define_formatter('javascriptreact', 'prettier')
define_formatter('typescript', 'prettier')
define_formatter('typescriptreact', 'prettier')

-- Miscellaneous
define_server 'jsonls' -- from hrsh7th/vscode-langservers-extracted
