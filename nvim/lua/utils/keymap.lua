M = {}

M.map = function(keys, callback, extra)
    local mode = (extra and extra.mode) or 'n'
    local desc = (extra and extra.desc) or nil
    local opts = (extra and extra.opts) or { desc = desc }
    vim.keymap.set(mode, keys, callback, opts)
end

M.mapdesc = function(keys, callback, desc)
    M.map(keys, callback, { desc = desc })
end

return M

