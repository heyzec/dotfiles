return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  cond = true,
  branch = 'main',
  config = function()
    require('nvim-treesitter-textobjects').setup {
      -- 1.1. Select text objects
      select = {
        enable = true,
        lookahead = true, -- if cursor is not on textobject, jump forward to next one
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
    }

    local select = require('nvim-treesitter-textobjects.select').select_textobject

    vim.keymap.set({ 'x', 'o' }, 'al', function()
      select('@loop.outer', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'il', function()
      select('@loop.inner', 'textobjects')
    end)

    vim.keymap.set({ 'x', 'o' }, 'af', function()
      select('@function.outer', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'if', function()
      select('@function.inner', 'textobjects')
    end)

    vim.keymap.set({ 'x', 'o' }, 'ac', function()
      select('@class.outer', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'ic', function()
      select('@class.inner', 'textobjects')
    end)

    vim.keymap.set({ 'x', 'o' }, 'am', function()
      select('@comment.outer', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'im', function()
      select('@comment.inner', 'textobjects')
    end)

    vim.keymap.set({ 'x', 'o' }, 'aa', function()
      select('@parameter.outer', 'textobjects')
    end)
    vim.keymap.set({ 'x', 'o' }, 'ia', function()
      select('@parameter.inner', 'textobjects')
    end)

    -- local.scope
  end,
}
