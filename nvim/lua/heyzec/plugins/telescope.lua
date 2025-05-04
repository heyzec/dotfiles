return {
  -- { 'ibhagwan/fzf-lua' },
  {
    'nvim-telescope/telescope.nvim',
    -- enabled = false,
    event = 'VimEnter', -- is this needed?
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
      -- },
      -- Use Neovim APIs to set pick to telescope, alowing default core to use telescope
      -- E.g. LSP Code action to use Telescoep instead of ???
      'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
      -- TODO: Cleanup
      local telescope = require 'telescope'
      telescope.setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          -- fzf = {
          --   fuzzy = true, -- false will only do exact matching
          --   override_generic_sorter = true, -- override the generic sorter
          --   override_file_sorter = true, -- override the file sorter
          --   case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
          --   -- the default case_mode is "smart_case"
          -- },
        },
      }

      telescope.load_extension 'ui-select'
      -- telescope.load_extension 'fzf'
      -- pcall(require('telescope').load_extension, 'ui-select')
      -- Enable Telescope extensions if they are installed
    end,
  },
}
