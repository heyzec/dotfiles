local vimrc = vim.fn.stdpath("config") .. "/vimrc"
vim.cmd.source(vimrc)

require('.')


-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ timeout = 800 })
  end,
  group = highlight_group,
  pattern = '*',
})

