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

require("lazy").setup({
    -- "Comment.nvim?"
    "neovim/nvim-lspconfig",                -- required for nvim LSP


    "williamboman/mason.nvim",              -- Manage external editor tooling i.e LSP servers
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "williamboman/mason-lspconfig.nvim",

    {
        "hrsh7th/nvim-cmp",                     -- Autocompletion
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",

            "hrsh7th/cmp-nvim-lsp",
        },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ':TSUpdate',
    },
    'nvim-treesitter/nvim-treesitter-refactor',
    'nvim-treesitter/nvim-treesitter-context',


    'nvim-lua/plenary.nvim',
    'jcdickinson/codeium.nvim',
})
