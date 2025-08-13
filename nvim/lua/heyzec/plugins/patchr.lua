return {
  'nhu/patchr.nvim',
  ---@type patchr.config
  opts = {
    plugins = {
      ['plantuml-previewer.vim'] = {
        '/home/heyzec/dotfiles/nvim/plantuml-previewer.patch',
      },
    },
  },
}
