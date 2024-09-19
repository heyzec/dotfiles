require('lazy-nvim')
require('config.keymaps')

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

vim.api.nvim_create_autocmd('ModeChanged', {
    pattern = { 'n:i', 'v:s' },
    desc = 'Disable diagnostics in insert and select mode',
    callback = function(e) vim.diagnostic.disable(e.buf) end
})
vim.api.nvim_create_autocmd('ModeChanged', {
    pattern = 'i:n',
    desc = 'Enable diagnostics when leaving insert mode',
    callback = function(e) vim.diagnostic.enable(e.buf) end
})

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.INFO] = '',
            [vim.diagnostic.severity.HINT] = '',
        },
    },
})
