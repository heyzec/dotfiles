-- Show lightbulb icon when LSP code action available
return {
  'kosayoda/nvim-lightbulb',
  config = function()
    require('nvim-lightbulb').setup {
      virtual_text = { enabled = true },
      autocmd = { enabled = true },
    }
  end,
}
