return {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    lazy = false,
    keys = {
        vim.keymap.set("n", "<leader>e", ":Neotree toggle filesystem<CR>"),
        vim.keymap.set("n", "<leader>b", ":Neotree toggle buffers<CR>"),
    },
    config = function()
        require("neo-tree").setup({
            filesystem = {
                -- To open neo-tree when nvim called with a directory
                hijack_netrw_behavior = "open_default";
            }
        })
    end
}
