-- Better integration of Treesitter for language-aware features, e.g. improved syntax highlighting
return {
  {
    'nvim-treesitter/nvim-treesitter',
    cond = true, -- load this plugin, even in VS Code
    -- update parsers when lazy.nvim updates this plugin
    build = ':TSUpdate',
    event = 'VeryLazy',
    dependencies = {
      -- Extra modules
      { 'nvim-treesitter/nvim-treesitter-textobjects', cond = true },
    },
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

      -- ========== Configure extra modules ==========
      -- 1. Text objects
      -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
      textobjects = {
        -- 1.1. Select text objects
        select = {
          enable = true,
          lookahead = true, -- if cursor is not on textobject, jump forward to next one
          keymaps = {
            ['al'] = { query = '@loop.outer', desc = 'outer loop' },
            ['il'] = { query = '@loop.inner', desc = 'inner loop' },
            ['af'] = { query = '@function.outer', desc = 'outer function' },
            ['if'] = { query = '@function.inner', desc = 'inner function' },
            ['ac'] = { query = '@class.outer', desc = 'outer class' },
            ['ic'] = { query = '@class.inner', desc = 'inner class' },
            ['am'] = { query = '@comment.outer', desc = 'outer comment' },
            ['im'] = { query = '@comment.inner', desc = 'inner comment' },
            ['aa'] = { query = '@parameter.outer', desc = 'outer parameter' },
            ['ia'] = { query = '@parameter.inner', desc = 'inner parameter' },
          },
          selection_modes = {
            ['@loop.outer'] = 'V',
            ['@function.outer'] = 'V',
            ['@class.outer'] = 'V',
            ['@comment.outer'] = 'V',
            ['@parameter.outer'] = 'v',
          },
        },
        -- 1.2. Swap text objects (unused)
        -- 1.3. Move to next/prev text object
        move = {
          enable = true,
          goto_next_start = {
            [']a'] = '@parameter.outer',
          },
        },
        -- 1.4. Peek text objects in floating window (unused)
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  -- Show context of the current function
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    opts = {
      mode = 'cursor',
      max_lines = 3,
    },
  },
}
