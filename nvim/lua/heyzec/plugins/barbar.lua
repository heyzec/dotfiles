-- Using barbar as a harpoon-like workflow
-- https://github.com/romgrk/barbar.nvim/issues/525
return {
  'romgrk/barbar.nvim',
  dependencies = {
    -- 'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
    'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
  },
  version = '^1.0.0',
  cmd = { 'BufferPick', 'BufferGoto', 'BufferPin' },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  opts = {
    auto_hide = 0,
    icons = {
      pinned = { button = '', filename = true, extension = true },
    },
    -- Hide inactive buffers and file extensions. Other options are `alternate`, `current`, and `visible`.
    hide = {
      current = true, -- Hide the current buffer
      visible = true, -- Hide visible (active) buffers
      inactive = true, -- Hide inactive (hidden) buffers
      alternate = true, -- Hide alternate buffers
    },
  },
  keys = {
    { 'gt', '<cmd>BufferNext<cr>', mode = 'n', desc = '📌 Go to next tab' },
    { 'gT', '<cmd>BufferPrevious<cr>', mode = 'n', desc = '📌 Go to previous tab' },
  },
}
