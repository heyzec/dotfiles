-- Hover plugin framework for Neovim
-- To show multiple info in hover window
return {
    "lewis6991/hover.nvim",
    lazy = false,
    config = function()
        require("hover").setup {
            init = function ()
                require("hover.providers.lsp")
                require("hover.providers.diagnostic")
                require("hover.providers.man")
            end
        }
    end,
}
