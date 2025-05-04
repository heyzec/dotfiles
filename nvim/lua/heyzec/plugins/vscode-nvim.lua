return {
  'Mofiqul/vscode.nvim',
  priority = 1000, -- load this before all the other plugins
  config = function()
    -- set the colorscheme
    vim.cmd.colorscheme 'vscode'
  end,
}
