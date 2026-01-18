-- Apply git patch to plugins loaded via lazy.nvim
-- Run :Patchr apply when necessary
local config_dir = vim.fn.stdpath 'config'
return {
  'nhu/patchr.nvim',
  ---@module 'patchr'
  ---@type patchr.config
  opts = {
    plugins = {
      ['hover.nvim'] = {
        config_dir .. '/lua/heyzec/plugins/hover.patch'
      },
    },
  },
}
