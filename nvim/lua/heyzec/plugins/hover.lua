-- Hover plugin framework for Neovim
-- To show multiple info in hover window
return {
  'lewis6991/hover.nvim',
  event = 'InsertEnter',
  opts = {
    init = function()
      -- Define your providers here
      require 'hover.providers.lsp'
      require 'hover.providers.diagnostic'
      require 'hover.providers.man'
    end,
  },
}
