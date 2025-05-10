-- local debug = require('utils.lua').debug
-- local dump = require('utils.lua').dump

local M = {}

-- Convenience wrapper around vim.keymap.set with sane defaults
M.map = function(keys, callback, extra)
    local mode = (extra and extra.mode) or 'n'
    local desc = (extra and extra.desc) or nil
    local opts = (extra and extra.opts) or { desc = desc }
    vim.keymap.set(mode, keys, callback, opts)
end


-- Convenience wrapper around vim.keymap.set for easy descriptions
M.map_desc = function(keys, callback, desc)
    M.map(keys, callback, { desc = desc })
end

-- Select callback based on whether neovim is embedded in vscode
local conditional = function(normal_callback, vscode_callback)
    if not vim.g.vscode then
        return normal_callback
    else
        return vscode_callback
    end
end

--- @alias action { [1]: string, [2]: function }

--- Create an action type, a container that holds callbacks
--- @param desc string
--- @param normal_callback function | nil
--- @param vscode_callback function | nil
--- @return action | nil
M.create_action = function(desc, normal_callback, vscode_callback)
    if not vim.g.vscode and normal_callback then
        return { desc, normal_callback }
    end
    if vim.g.vscode and vscode_callback then
        return { desc, vscode_callback }
    end
    return nil
end

local function is_action(t)
    if type(t) ~= 'table' then
        return false
    end
    if #t < 2 then
        return false
    end
    if type(t[1]) ~= 'string' or type(t[2]) ~= 'function' then
        return false
    end
    if #t == 2 then
        return true
    end
    if #t == 3 and type(t[3]) == 'function' then
        return true
    end
    return false
end

--- @alias bind { [1]: string, [2]: action }

--- Create a bind type
--- @param mode string
--- @param action action | nil
--- @return bind | nil
M.create_bind = function(mode, action)
    if not action then
        return nil
    end
    return { mode, action }
end

local function is_bind(t)
    if type(t) ~= 'table' then
        return false
    end
    if #t ~= 2 then
        return false
    end
    return type(t[1]) == 'string' and is_action(t[2])
end

local function map_table_helper(tab, keylist)
    -- Base cases
    if tab == nil then
        return
    end
    if type(tab) == 'function' then
        local key = table.concat(keylist)
        M.map_desc(key, tab)
    end
    if is_action(tab) then
        local key = table.concat(keylist)
        M.map_desc(key, tab[2], tab[1])
        return
    end
    if is_bind(tab) then
        local key = table.concat(keylist)
        local action = tab[2]
        M.map(key, action[2], {
            mode = tab[1],
            desc = action[1],
        })
        return
    end

    for k, v in pairs(tab) do
        if type(k) == 'number' then
            local prefix = table.concat(keylist, '', 1, #keylist - 1)
            local key = keylist[#keylist]
            if whichkey then
                whichkey.add({
                    { prefix .. key, group = v },
                })
            end
            goto continue
        end

        -- Perform backtracking
        table.insert(keylist, k)
        map_table_helper(v, keylist)
        table.remove(keylist)

        ::continue::
    end
end

-- Configures multiple mappings in a form of a nested table
M.map_table = function(mappings)
    if not vim.g.vscode then
        --- @diagnostic disable-next-line: lowercase-global
        whichkey = require('which-key')
    end
    map_table_helper(mappings, {})
end

return M
