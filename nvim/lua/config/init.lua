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

local plugins = "plugins"

require("lazy").setup(plugins, {})
--require "lazy-setup"
-- require("lazy").setup({
--     -- "Comment.nvim?"
--     "neovim/nvim-lspconfig",                -- required for nvim LSP
-- 
-- 
--     "folke/neodev.nvim", -- anotations for neovim api functions
-- 
--     'jcdickinson/codeium.nvim',
-- 
--     { "lukas-reineke/indent-blankline.nvim" },
-- })
