-- Save buffer automatically
local excluded_filetypes = {
  'fyler',
}

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
    condition = function(buf)
      return vim.g.auto_save and not vim.tbl_contains(excluded_filetypes, vim.fn.getbufvar(buf, '&filetype'))
    end,
  },
}
