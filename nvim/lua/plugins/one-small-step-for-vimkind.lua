-- Debug lua code and configs running in a Neovim instance
return {
    "jbyuki/one-small-step-for-vimkind",
    keys = {
        {
            '<leader>dl',
            function()
                require('osv').launch { port = 8086 }
            end,
            desc = 'Launch Lua adapter',
        },
    },

}
