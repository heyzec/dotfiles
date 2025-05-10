-- Save buffer automatically
return {
  -- Fork of pocco81/auto-save.nvim that is maintained
  'okuuva/auto-save.nvim',
  version = '^1.0.0',
  event = { 'InsertLeave', 'TextChanged' },
  init = function()
    -- Define a custom variable to control auto-save
    vim.g.auto_save = true
  end,
  opts = {
    condition = function()
      return vim.g.auto_save
    end,
  },
}
