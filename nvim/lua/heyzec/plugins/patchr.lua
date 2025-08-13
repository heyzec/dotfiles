return {
  'nhu/patchr.nvim',
  ---@type patchr.config
  opts = {
    plugins = {
      ['plantuml-previewer.vim'] = {
        -- TODO: Don't hardcode this username
        '/Users/SIPSS0377/dotfiles/nvim/plantuml-previewer.patch',
      },
    },
  },
}
