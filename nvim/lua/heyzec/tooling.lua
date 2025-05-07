local lsp_utils = require 'heyzec.utils.tooling'
local define_server = lsp_utils.define_server
local define_formatter = lsp_utils.define_formatter

-- These tools need to be made available in the PATH
-- Possibly by editing nix/modules/neovim.nix

-- Lua
define_server('lua_ls', {
  capabilities = {},
})
define_formatter('lua', 'stylua')

-- Nix
define_server 'nil_ls'
define_formatter('nix', 'alejandra')

-- Others
define_server 'jsonls' -- hrsh7th/vscode-langservers-extracted
define_formatter('typescriptreact', 'prettier')
-- javascript = { "prettierd", "prettier", stop_after_first = true },

define_formatter('python', 'black')
