return {
    "numToStr/Comment.nvim",
    lazy = false,
    opts = {},
    keys = {
        vim.keymap.set("n", "<C-_>", function() require('Comment.api').toggle.linewise.current() end, { noremap = true, silent = true })
    }
}

