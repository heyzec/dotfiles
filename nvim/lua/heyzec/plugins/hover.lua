-- Show popup window with info from multiple sources
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
