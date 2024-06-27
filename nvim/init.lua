---@diagnostic disable: undefined-global

-- Source traditional vimrc first
local vimrc = vim.fn.stdpath("config") .. "/vimrc"
vim.cmd.source(vimrc)

-- Source lua config next
require('.')

-- Note to self: Place the bulk of lua config in the lua/init.lua file instead
-- This is because neodev only provides neovim annotations in that folder
