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
--- @param keys string
--- @param callback function | string
--- @param descriptor string
M.map = function(keys, callback, descriptor, extra)
  local mode, desc, icon
  desc, icon = parse_descriptor(descriptor)
  if extra then
    mode = extra.mode or 'n'
  end
  if whichkey then
    whichkey.add(vim.tbl_deep_extend('force', { keys, callback }, extra or {}, { mode = mode, desc = desc, icon = icon }))
  else
    vim.keymap.set(mode, keys, callback, extra or {})
  end
end

-- -- Convenience wrapper around vim.keymap.set for easy descriptions
-- M.map_desc = function(keys, callback, desc)
--   M.map(keys, callback, { desc = desc })
-- end

-- Wrapper to document key chains
M.map_prefix = function(prefix, descriptor)
  local desc, icon = parse_descriptor(descriptor)
  if whichkey then
    whichkey.add {
      { prefix, group = desc, icon = icon },
    }
  end
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

--- @class Base
--- @field type string

--- @class Action : Base
--- @field desc string
--- @field callback function | string

--- Create an action type, a container that holds callbacks
--- @param desc string Description of action
--- @param callback function | string Function / Ex command to perform action
--- @return Action
local function create_action(desc, callback)
  return { type = 'action', desc = desc, callback = callback }
end

--- Create an action based on whether Neovim is embedded in VS Code
--- @param desc string Description of action
--- @param normal_callback function | string | nil Function / Ex command to perform action in Neovim
--- @param vscode_callback function | string | nil Function / Ex command to perform action in VS Code
--- @return Action | nil
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
  return t.type == 'action'
end

--- @class Bindlet : Base
--- @field mode string
--- @field action Action
--- @field extra table

--- @class Bind : Base
--- @field binds Bindlet[]

--- Create a bind type
--- @param ... { [1]: string, [2]: Action, [3]: table | nil}
--- @return Bind | nil
M.create_bind = function(...)
  --- @type Bind
  local bind = { type = 'bind', binds = {} }
  local args = { ... }
  for _, v in ipairs(args) do
    local mode, action, extra = v[1], v[2], v[3]
    assert(mode ~= 'string')
    assert(is_action(action))
    assert(type(extra) == 'table' or extra == nil)
    local bindlet = { type = 'bindlet', mode = mode, action = action, extra = extra }
    vim.list_extend(bind.binds, { bindlet })
  end
  return bind
end

local function is_bind(t)
  return t.type == 'bind'
end

-- ========== Main function for parsing table and make mappings ==========

--- @param obj table | Action | Bind
--- @param keylist table
local function map_table_helper(obj, keylist)
  -- Base cases
  if obj == nil then
    return
  end
  if is_action(obj) then
    --- @cast obj Action
    local action = obj
    local key = table.concat(keylist)
    M.map(key, action.callback, action.desc)
    return
  end
  if is_bind(obj) then
    --- @cast obj Bind
    local bind = obj
    for _, bindlet in ipairs(bind.binds) do
      local key = table.concat(keylist)
      assert(type(bindlet.action.desc) == 'string')
      M.map(
        key,
        bindlet.action.callback,
        bindlet.action.desc,
        vim.tbl_deep_extend('force', bindlet.extra or {}, {
          mode = bindlet.mode,
        })
      )
    end
    return
  end

  for k, v in pairs(obj) do
    if k == 1 then
      -- Document existing key chains
      local prefix = table.concat(keylist)
      M.map_prefix(prefix, v)
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
