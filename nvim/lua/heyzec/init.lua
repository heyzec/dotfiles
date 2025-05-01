-- vim.g.heyzec_use_mason = false
require 'heyzec.tooling'

-- Think about the dependencies. heyzec.utils.lsp, lazy plugins (mason, formatter)
-- Mason will call lsp-config handler for installed LSPs. This seems to be a must
-- So, we need to setup our stuff before lazy

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

if init_debug then
  require('osv').launch { port = 8086, blocking = true }
  vim.cmd.sleep(1) -- without this, breakpoints seem to be not registered fast enough
end

require 'heyzec.keymaps'
