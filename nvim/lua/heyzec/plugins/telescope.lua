-- Fuzzy finder and pickers
return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      -- hard dependency: lua utilities library
      'nvim-lua/plenary.nvim',

      -- Extensions
      -- use Telescope as default picker in Neovim
      'nvim-telescope/telescope-ui-select.nvim',
      -- search undo history tree
      'debugloop/telescope-undo.nvim',
    },
    cmd = 'Telescope',
    config = function()
      local telescope = require 'telescope'
      telescope.setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable extensions
      telescope.load_extension 'ui-select'
      telescope.load_extension 'undo'
    end,
  },
}
