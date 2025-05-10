return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",

            -- Extensions
            "debugloop/telescope-undo.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
        },
        tag = "0.1.3",
        config = function ()
            local telescope = require('telescope')
            telescope.setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {}
                    }
                },
            })
            telescope.load_extension("undo")
            telescope.load_extension("ui-select")
        end,
        lazy = false,
    },
}

