-- Source traditional vimrc first
local vimrc = vim.fn.stdpath 'config' .. '/vimrc'
vim.cmd.source(vimrc)

-- Source lua config next
require 'heyzec'
