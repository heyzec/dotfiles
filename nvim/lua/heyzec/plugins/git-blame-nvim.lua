return {
  'f-person/git-blame.nvim',
  event = 'VeryLazy',
  opts = function()
    -- Make virtual text background transparent
    -- https://github.com/f-person/git-blame.nvim/issues/146
    local hl_cursor_line = vim.api.nvim_get_hl(0, { name = 'CursorLine' })
    local hl_comment = vim.api.nvim_get_hl(0, { name = 'Comment' })
    local hl_combined = vim.tbl_extend('force', hl_comment, { bg = hl_cursor_line.bg })
    vim.api.nvim_set_hl(0, 'CursorLineBlame', hl_combined)

    return {
      -- message with a margin of 2 spaces
      message_template = '  <author> (<date>) • <summary>',
      date_format = '%r', -- use relative date
      delay = 250,
      highlight_group = 'CursorLineBlame',
    }
  end,
}
