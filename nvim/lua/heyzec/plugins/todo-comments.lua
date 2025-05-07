-- Highlight todo in comments
return {
  'folke/todo-comments.nvim',
  event = 'VeryLazy',
  dependencies = {
    -- hard dependency: lua utilities library
    'nvim-lua/plenary.nvim',
  },
  opts = { signs = false },
}
