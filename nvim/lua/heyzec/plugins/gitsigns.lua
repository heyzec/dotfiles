-- Show git signs in the gutter, and other git integrations (e.g. blame, hunks)
return {
  'lewis6991/gitsigns.nvim',
  event = 'VeryLazy',
  opts = {
    -- 1. Signs
    signs = {}, -- use defaults
    -- 2. Blame
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 250,
      use_focus = false, -- show blame even when buffer not focused
    },
    -- message with a margin of 2 spaces
    current_line_blame_formatter = '  <author> (<author_time:%R>) • <summary>',
  },
  config = function(_, opts)
    require('gitsigns').setup(opts)
    -- Set sign colors
    -- the default of yellowish is harder to distinguish, use VS Code's blue
    vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = '#0078d4' })
    vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { link = 'Comment' })
  end,
}
