return {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    lazy = false,
    config = function()
        require("neo-tree").setup({
            filesystem = {
                -- To open neo-tree when nvim called with a directory
                hijack_netrw_behavior = "open_default",
            },
            window = {
                mappings = {
                    -- This tells neo-tree to use the default filesystem open command on the release of the left mouse button
                    ['<leftrelease>'] = 'open'
                }
            }
        })
    end
}
