return {
    'glacambre/firenvim',
    build = ":call firenvim#install(0)",
    config = function()
        vim.opt.guifont = "monospace:h10"
        vim.g.firenvim_config = {
            localSettings = {
                [".*"] = {
                    takeover = "once"
                },
                ["https?://www.google.com/"] = {
                    takeover = "never"
                },
                ["linkedin.com"] = {
                    takeover = "never"
                },
                ["https://sourceacademy.org"] = {
                    takeover = "never"
                },
                ["https://www.overleaf.com"] = {
                    takeover = "never"
                },
                ["https://docs.google.com"] = {
                    takeover = "never"
                },
                ["https://leetcode.com"] = {
                    takeover = "never"
                },
                ["localhost(:\\d+)?"] = {
                    takeover = "never"
                },
            }

        }
    end,
}
