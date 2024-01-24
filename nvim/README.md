# neovim

Single config for vim, neovim and neovim + VSCode

## More READMEs
- [./lua/config/README.md](lua/config) - Keymaps

## Directory structure
```
.
├── init.lua             entry point for neovim
├── vimrc                entry point for vim, contains basic configs and also sourced by neovim
├── plugins.vim          if vim, vim-plug will install some basic plugins 
└── lua/                 if neovim, files within this directory will be sourced
    ├── config/
    │   └── keymaps.lua  advanced keymaps
    ├── lazy-nvim.lua    lazy.nvim plugin manager
    └── plugins/         each file in this folder contains a plugin which lazy.nvim will install
```

## Plugins
Plugins organised according to sections in [vimawesome.com](https://vimawesome.com)

[lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager

**Language**
| | |
|---|---|
|[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)|Language Server Protocol (LSP) support|
|[mason](https://github.com/williamboman/mason.nvim)|installer for LSP servers, linters and formatters|
|[mason-lspconfig](https://github.com/williamboman/mason-lspconfig.nvim)|better mason and lsp-config integration|
|[mason-tool-installer](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim)|to declaratively specify which tools to automatically install via mason|
|[treesitter](https://github.com/nvim-treesitter/nvim-treesitter)|parser for better syntax highlighting|

**Completion & Helpers**
| | |
|---|---|
|[nvim-autopairs](https://github.com/windwp/nvim-autopairs)|autopair completion|
|[nvim-cmp](https://github.com/hrsh7th/nvim-cmp)|auto-completion support|
|[comment-nvim](https://github.com/numToStr/Comment.nvim)|commenting|

**Code display**
| | |
|---|---|
|[indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim)|indentation UI|
|[nvim-colorizer](https://github.com/norcalli/nvim-colorizer.lua)|colorize text that represent colors|
|[rainbow-delimeters](https://github.com/HiPhish/rainbow-delimiters.nvim)|colorize bracket pairs, powered by treesitter|
|[transparent-nvim](https://github.com/xiyaowong/transparent.nvim)|background transparency|

**Integrations**
| | |
|---|---|
|[gitsigns](https://github.com/lewis6991/gitsigns.nvim)|git status signs|

**Interface**
| | |
|---|---|
|[telescope](https://github.com/nvim-telescope/telescope.nvim)|fuzzy finder and pickers|
|[neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim)|file tree explorer|
|[lualine](https://github.com/nvim-lualine/lualine.nvim)|status line|
|[vscode-nvim](https://github.com/Mofiqul/vscode.nvim)|color scheme inspired by VSCode|
|[which-key](https://github.com/folke/which-key.nvim)|show available keybindings in popup|

## Useful Resources
- [Vimjoyer - Neovim Starter Setup Guide](https://www.youtube.com/watch?v=Co7gcSvq6jA)
- [The Rad Lectures - How to setup Neovim from Scratch - Complete Guide](https://www.youtube.com/watch?v=ZjMzBd1Dqz8)
- [typecraft - From 0 to IDE in NEOVIM from scratch](https://www.youtube.com/watch?v=zHTeCSVAFNY)

