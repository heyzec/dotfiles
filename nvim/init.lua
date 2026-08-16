-- Source traditional vimrc first
local vimrc = vim.fn.stdpath 'config' .. '/vimrc'
vim.cmd.source(vimrc)

vim.env.ANTRHOPIC_API_KEY = vim.fn.getenv("ANTRHOPIC_API_KEY")
vim.env.AVANTE_ANTRHOPIC_API_KEY = vim.fn.getenv("ANTRHOPIC_API_KEY")

-- Source lua config next
require 'heyzec'
