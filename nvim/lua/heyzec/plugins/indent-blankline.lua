-- Show indentation guides
return {
  'lukas-reineke/indent-blankline.nvim',
  event = 'VeryLazy',
  main = 'ibl',
  config = function()
    -- Follow VSCode defaults (3 colors, no red)
    local highlight = {
      'RainbowYellow',
      'RainbowViolet',
      'RainbowBlue',
    }

    -- rainbow-delimiters.nvim integration: color indent based on scope using Treesitter
    local hooks = require 'ibl.hooks'
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
      vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
      vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
    end)
    vim.g.rainbow_delimiters = { highlight = highlight }

    require('ibl').setup { scope = { highlight = highlight } }

    hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
  end,
}
