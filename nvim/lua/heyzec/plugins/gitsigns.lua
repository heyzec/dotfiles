-- git related signs to the gutter, as well as utilities for managing changes
return {
  'lewis6991/gitsigns.nvim',
  opts = {
    -- 1. Signs
    signs = {}, --use defaults
    -- 2. Blame
    current_line_blame = true,
    current_line_blame_opts = {
      delay = 250,
      use_focus = false,
    },
    -- message with a margin of 2 spaces
    current_line_blame_formatter = '  <author> (<author_time:%R>) • <summary>',
  },
  config = function(_, opts)
    -- Set sign colors
    -- the default of yellowish is harder to distinguish, use vscode's blue
    vim.cmd [[:highlight GitSignsChange guifg=#0078d4]]
    vim.cmd [[:highlight link GitSignsCurrentLineBlame Comment]]
    require('gitsigns').setup(opts)
  end,
}
