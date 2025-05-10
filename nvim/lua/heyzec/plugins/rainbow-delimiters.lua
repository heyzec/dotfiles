return {
    "hiphish/rainbow-delimiters.nvim",
    config = function ()
        require('rainbow-delimiters.setup').setup {
            -- Modified to not use red, instead follow VSCode default
            highlight = {
                'RainbowDelimiterYellow',
                'RainbowDelimiterViolet',
                'RainbowDelimiterBlue',
            },
        }
    end,
}

