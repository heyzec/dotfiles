-- Right-click context menu
return {
  'nvzone/menu',
  dependencies = {
    'nvzone/volt',
  },
  config = function()
    -- mouse users + nvimtree users!
    vim.keymap.set('n', '<RightMouse>', function()
      vim.cmd.exec '"normal! \\<RightMouse>"'

      local options = vim.bo.ft == 'NvimTree' and 'nvimtree' or 'default'
      require('menu').open(options, { mouse = true })
    end, {})
    -- vim.cmd 'colorscheme vscode'
  end,
}
