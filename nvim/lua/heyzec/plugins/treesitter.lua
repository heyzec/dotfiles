return {
  -- Lock to specific commmit because triggering indent will lag on dart files:
  -- https://github.com/nvim-treesitter/nvim-treesitter/issues/4945#issuecomment-1691168369
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',

    -- event = vim.g.vscode and nil or { "LazyFile", "VeryLazy" },
    -- lazy = not vim.g.vscode,
    lazy = false,
    cond = true, -- always load this plugin, even if vscode

    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treeitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries, which we make available
      -- during startup.
      require('lazy.core.loader').add_to_rtp(plugin)
      require 'nvim-treesitter.query_predicates'
    end,
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects', cond = true },
      { 'nvim-treesitter/nvim-treesitter-refactor', cond = true },
    },
    cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
    keys = {
      { '<c-space>', desc = 'Increment selection' },
      { '<bs>', desc = 'Decrement selection', mode = 'x' },
    },
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      -- Install these parsers (nvim-treesitter says these must be needed!)
      -- ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline' },
      auto_install = true,
      -- Note to self: Do not install automatically, since it is likely to fail on Nix systems!
      -- auto_install = false,

      -- ========== Configure builtin modules ==========
      -- 1. Syntax highlighting
      highlight = { enable = true },
      -- 2. Incremental selection
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-space>',
          node_incremental = '<C-space>',
          scope_incremental = false,
          node_decremental = '<bs>',
        },
      },
      -- 3. Indenting
      indent = { enable = true },
      -- 4. Folding
      -- NA

      -- ========== Configure extra modules ==========
      -- 1. Text objects
      -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
      textobjects = {
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
        },
        selection_modes = {
          ['@loop.outer'] = 'V',
          ['@function.outer'] = 'V',
          ['@class.outer'] = 'V',
          ['@comment.outer'] = 'V',
          ['@parameter.outer'] = 'v',
        },
        move = {
          enable = true,
          goto_next_start = {
            [']a'] = '@parameter.outer',
          },
        },
      },
      -- TODO: Remove this plugin
      -- 2. Refactor
      -- https://github.com/nvim-treesitter/nvim-treesitter-refactor
      refactor = {
        -- 1.1. Highlight definitions and usages of symbol under cursor
        -- Note: ~/Desktop/kickstart-modular.nvim/lua/kickstart/plugins/lspconfig.lua:125 provide a LSP-based method
        highlight_definitions = { enable = false, clear_on_cursor_move = true },
        -- 1.2. Highlight current scope of cursor
        -- highlting scope is distracting
        highlight_current_scope = { enable = false },
        -- 1.3. Smart rename: an alternative to LSP-based rename (grn)
        smart_rename = { enable = true, keymaps = { smart_rename = 'grN' } },
        -- 1.4. Navigation
        navigation = {
          enable = true,
          keymaps = {
            goto_definition = 'gnd',
            list_definitions = 'gnD',
            list_definitions_toc = 'gO',
            goto_next_usage = 'gn',
            goto_previous_usage = 'gp',
          },
        },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },

  -- Show context of the current function
  {
    'nvim-treesitter/nvim-treesitter-context',
    -- event = "LazyFile",
    enabled = true,
    opts = { mode = 'cursor', max_lines = 3 },
    cond = true,
  },
}
