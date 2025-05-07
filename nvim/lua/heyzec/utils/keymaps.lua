-- local debug = require('utils.lua').debug
-- local dump = require('utils.lua').dump

local M = {}
local whichkey

-- ========== Keymap wrappers ==========

--- Attempts to parse icon and description from a descriptor.
--- A descriptor is a string of the format "<one-unicode-len-icon> <desc>"
--- @param s string
local function parse_descriptor(s)
  local matches = {}
  for match in string.gmatch(s, '%S+') do
    table.insert(matches, match)
  end
  -- Assume icon is not ASCII
  if string.byte(matches[1]) <= 127 then
    return s, nil
  end

  local icon = matches[1]
  local description = table.concat(matches, ' ', 2)
  return description, icon
end

-- Convenience wrapper around vim.keymap.set with sane defaults
M.map = function(keys, callback, extra)
  local mode, desc, icon
  if extra then
    mode = extra.mode or 'n'
    -- local desc = (and extra.desc) or nil
    if extra.desc then
      desc, icon = parse_descriptor(extra.desc)
    end
  end
  if whichkey then
    whichkey.add { keys, callback, mode = mode, desc = desc, icon = icon }
  else
    vim.keymap.set(mode, keys, callback, { desc = desc })
  end
end

-- Convenience wrapper around vim.keymap.set for easy descriptions
M.map_desc = function(keys, callback, desc)
  M.map(keys, callback, { desc = desc })
end

--
M.map_prefix = function(prefix, desc, icon)
  if whichkey then
    whichkey.add {
      { prefix, group = desc, icon = icon },
    }
  end
end

--- @alias action { [1]: string, [2]: function | string }

--- Create an action type, a container that holds callbacks
--- @param desc string Description of action
--- @param callback function | string Function / Ex command to perform action
--- @return action
local function create_action(desc, callback)
  return { desc, callback }
end

-- ========== prequire, a wrapper of require ==========

--- Mock object which does not raise errors when indexed or called.
local sentinel
sentinel = setmetatable({}, {
  __call = function()
    return sentinel
  end,
  __index = function()
    return sentinel
  end,
})

--- Attempts to `require` a module.
--- Returns a mock object on failure.
M.prequire = function(module_name)
  local status, lib = pcall(require, module_name)
  if status then
    return lib
  end
  return sentinel
end

-- ========== Custom container types: Actions and Binds ==========

--- Create an action based on whether Neovim is embedded in VS Code
--- @param desc string Description of action
--- @param normal_callback function | string | nil Function / Ex command to perform action in Neovim
--- @param vscode_callback function | string | nil Function / Ex command to perform action in VS Code
--- @return action | nil
M.create_conditional_action = function(desc, normal_callback, vscode_callback)
  if not vim.g.vscode and normal_callback then
    return create_action(desc, normal_callback)
  end
  if vim.g.vscode and vscode_callback then
    return create_action(desc, vscode_callback)
  end
  return nil
end

local function is_action(t)
  if type(t) ~= 'table' then
    return false
  end
  if #t ~= 2 then
    return false
  end
  if type(t[1]) ~= 'string' then
    return false
  end
  if type(t[2]) ~= 'function' and type(t[2]) ~= 'string' then
    return false
  end
  return true
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

-- ========== Main function for parsing table and make mappings ==========

--- @param tbl table
local function map_table_helper(tbl, keylist)
  -- Base cases
  if tbl == nil then
    return
  end
  if type(tbl) == 'function' then
    local key = table.concat(keylist)
    M.map_desc(key, tbl)
    return
  end
  if is_action(tbl) then
    local key = table.concat(keylist)
    M.map_desc(key, tbl[2], tbl[1])
    return
  end
  if is_bind(tbl) then
    local key = table.concat(keylist)
    local action = tbl[2]
    M.map(key, action[2], {
      mode = tbl[1],
      desc = action[1],
    })
    return
  end

  for k, v in pairs(tbl) do
    -- Detecting metadata
    if k == 1 then
      local prefix = table.concat(keylist)
      -- local prefix = table.concat(keylist, '', 1, #keylist - 1)
      -- local key = keylist[#keylist]
      local desc, icon = parse_descriptor(v)
      -- elseif type(v) == 'table' then
      --   group = v[1]
      --   icon = v.icon
      -- else
      -- end

      -- Document existing key chains
      M.map_prefix(prefix, desc, icon)
      -- if whichkey then
      --   whichkey.add {
      --     { prefix, group = desc, icon = icon },
      --   }
      -- end
      goto continue
    end

    -- Perform backtracking
    table.insert(keylist, k)
    map_table_helper(v, keylist)
    table.remove(keylist)

    ::continue::
  end
end

--- Configures multiple mappings in a form of a nested table
--- @param mappings table
M.map_table = function(mappings)
  if not vim.g.vscode then
    whichkey = require 'which-key'
  end
  map_table_helper(mappings, {})
end

return M
