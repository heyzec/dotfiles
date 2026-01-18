-- Better integration of Treesitter for language-aware features, e.g. improved syntax highlighting
return {
  {
    'nvim-treesitter/nvim-treesitter',
    cond = true, -- load this plugin, even in VS Code
    branch = 'main',
    -- update parsers when lazy.nvim updates this plugin
    build = ':TSUpdate',
    event = 'VeryLazy',
  },
  {
    -- Wrapper plugin after nvim-treesitter rewrite
    'MeanderingProgrammer/treesitter-modules.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ---@module 'treesitter-modules'
    ---@type ts.mod.UserConfig
    opts = {
      -- install these parsers (nvim-treesitter says these must be needed!)
      ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline' },
      auto_install = true,

      -- ========== Configure builtin modules ==========
      -- 1. Syntax highlighting
      highlight = {
        enable = true,
        disable = {
          'tmux', -- TS parser (Freed-Wu/tree-sitter-tmux) is broken on my config and does worse than Vim's parser
        },
      },
      -- 2. Incremental selection
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-Space>',
          node_incremental = '<C-Space>',
          scope_incremental = false,
          node_decremental = '<BS>',
        },
      },
      -- 3. Indenting
      indent = { enable = true },
      -- 4. Folding (configured separately, not via opts)
    },
  },
  {
    -- Show context of the current function
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    opts = {
      mode = 'cursor',
      max_lines = 3,
    },
  },
}
