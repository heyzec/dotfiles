return {
    "numToStr/Comment.nvim",
    -- lazy = false,
    config = function()
        require('Comment').setup()
        vim.keymap.set("n", "<C-_>", require('Comment.api').toggle.linewise.current)
    end,
}

