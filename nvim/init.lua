-- Source traditional vimrc first
local vimrc = vim.fn.stdpath 'config' .. '/vimrc'
vim.cmd.source(vimrc)
-- Load .vimrc
-- vim.cmd [[runtime .vimrc]]

-- Source lua config next
require 'heyzec'

-- Note to self: Place the bulk of lua config in the lua/init.lua file instead
-- This is because neodev only provides neovim annotations in that folder
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
