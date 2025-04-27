-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Setup lazy? Arrange later
local plugins = 'heyzec.plugins' -- the folder
require('lazy').setup(plugins, {
  -- defaults = {
  --   cond = not_vscode,
  -- },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = true,
    notify = false,
  },
})

local setup = require 'heyzec.utils.lsp'
setup('lua_ls')
setup('nil_ls')
setup('jsonls')
-- require('lspconfig').lua_ls.setup {}
-- require('lspconfig').nil_ls.setup {}
-- require('lspconfig').jsonls.setup {}

require 'heyzec.keymaps'
