return {
  -- Fork of pocco81/auto-save.nvim that is maintained
  'okuuva/auto-save.nvim',
  config = function(_, opts)
    -- Define a custom variable to control auto-save
    vim.g.auto_save = true
    require('auto-save').setup {
      condition = function()
        return vim.g.auto_save
      end,
    }
  end,
}
