return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter', -- is this needed?
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    -- TODO: Cleanup
    require('telescope').setup {
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
  end,
}
