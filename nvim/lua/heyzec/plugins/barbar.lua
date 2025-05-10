-- Tabline plugin, but used as a harpoon-like workflow
-- See https://github.com/romgrk/barbar.nvim/issues/525
return {
  'romgrk/barbar.nvim',
  dependencies = {
    -- soft dependency: for file icons
    -- 'nvim-tree/nvim-web-devicons',
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
    { 'gt', '<Cmd>BufferNext<CR>', mode = 'n', desc = '📌 Go to next tab' },
    { 'gT', '<Cmd>BufferPrevious<CR>', mode = 'n', desc = '📌 Go to previous tab' },
  },
}
