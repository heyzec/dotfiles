-- Show popup window with info from multiple sources
return {
  'lewis6991/hover.nvim',
  event = 'InsertEnter',
  opts = {
    providers = {
      -- Define your providers here, see repo for other available providers
      -- default config includes the dictionary provider, we don't want that
      'hover.providers.diagnostic',
      'hover.providers.lsp',
      'hover.providers.dap',
      'hover.providers.man',
    },
  },
}
