return {
    "jackMort/ChatGPT.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim"
    },
    lazy = true,
    cmd = {
        "ChatGPT",
        "ChatGPTRun",
        "ChatGPTActAs",
        "ChatGPTCompleteCode",
        "ChatGPTEditWithInstructions",
    },
    config = function()
        local file = vim.fn.fnamemodify(vim.fn.expand("$MYVIMRC"), ":p:h") .. "/chatgpt-key.gpg"
        require("chatgpt").setup({
            api_key_cmd = "gpg --decrypt " .. file
        })
    end,
}
