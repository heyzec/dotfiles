return {
  'creativenull/efmls-configs-nvim',
  version = 'v1.x.x',
  dependencies = { 'neovim/nvim-lspconfig' },
  config = function()
    require('lspconfig').efm.setup({
      filetypes = { 'typescript', 'lua', 'nix', 'json' },
      init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
      },
      settings = {}
    })
  end,
}
