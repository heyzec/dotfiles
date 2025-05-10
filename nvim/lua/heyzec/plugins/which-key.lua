-- Show available keybindings in popup
return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    -- Don't set icons automatically based on desc
    icons = { rules = false },
  },
}
