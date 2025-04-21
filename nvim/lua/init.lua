require('lazy-nvim')

if init_debug then
    require("osv").launch({port=8086, blocking=true})
    vim.cmd.sleep(1) -- Without this, breakpoints seem to be not registered fast enough
end

require('config.keymaps')
require('config.autocommands')


vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.INFO] = '',
            [vim.diagnostic.severity.HINT] = '',
        },
    },
})
