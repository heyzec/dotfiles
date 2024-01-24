-- Install package manager lazy.nvim automatically
-- See https://github.com/folke/lazy.nvim#-installation
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local not_vscode = not vim.g.vscode

require('utils.plugin').setup()

local plugins = "plugins"
require("lazy").setup(plugins, {
  defaults = {
    cond = not_vscode,
  },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = true,
    notify = false,
  },
})

