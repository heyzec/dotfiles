return {
  'Mofiqul/vscode.nvim',
  priority = 1000, -- load this before all the other start plugins.
  config = function()
    -- load the colorscheme
    vim.cmd.colorscheme 'vscode'
  end,
}
