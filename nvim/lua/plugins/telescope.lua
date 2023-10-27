return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "debugloop/telescope-undo.nvim",
    },
    tag = "0.1.3",
    lazy = false,
    config = function()
        local telescope = require('telescope')
        telescope.setup()
        telescope.load_extension("undo")

    end,
    keys = {
        vim.keymap.set("n", "<leader>fa", ":Telescope <CR>"),
        vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>"),
        vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>"),
        vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>"),
        vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>"),
        vim.keymap.set("n", "<leader>fk", ":Telescope keymaps<CR>"),
        vim.keymap.set("n", "<leader>fu", ":Telescope undo<CR>"),
    },
}
