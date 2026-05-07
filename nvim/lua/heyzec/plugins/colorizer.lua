-- Highlight text representing color codes with actual colors
return {
  'catgoose/nvim-colorizer.lua',
  event = 'BufReadPost',
  config = function()
    require('colorizer').setup()
  end,
}
