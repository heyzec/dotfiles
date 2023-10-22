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
    "folke/neodev.nvim", -- anotations for neovim api functions

    {
        -- Provide code completion menu
        "hrsh7th/nvim-cmp",                     -- Autocompletion
        dependencies = {
            -- Engine
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip', -- integrates luasnip with cmp

            -- Completion
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",

            -- Snippets
            'rafamadriz/friendly-snippets',

            "hrsh7th/cmp-nvim-lsp",
        },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ':TSUpdate',
    },
    'nvim-treesitter/nvim-treesitter-refactor',
    'nvim-treesitter/nvim-treesitter-context',
    'nvim-treesitter/nvim-treesitter-textobjects',

    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.2',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },


    'nvim-lua/plenary.nvim',
    'jcdickinson/codeium.nvim',

    "lewis6991/gitsigns.nvim",

    {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
          "MunifTanjim/nui.nvim",
        }
    },
    { "norcalli/nvim-colorizer.lua" },
    { "nvim-tree/nvim-tree.lua" },
})
