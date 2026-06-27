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
        config_dir .. '/lua/heyzec/plugins/hover.patch',
      },
      -- Refer to https://github.com/weirongxu/plantuml-previewer.vim/issues/94
      ['plantuml-previewer.vim'] = {
        config_dir .. '/lua/heyzec/plugins/plantuml-previewer.patch',
      },
    },
  },
}
