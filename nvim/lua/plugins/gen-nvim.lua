return {
    "David-Kunz/gen.nvim",
    config = function ()
        vim.keymap.set('v', '<leader>]', ':Gen<CR>')
        vim.keymap.set('n', '<leader>]', ':Gen<CR>')
    end,
}
