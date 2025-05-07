-- Additional plugins for LSPs
return {
  {
    -- Configure LuaLS with annotations for Neovim functions APIs
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  -- Show LSP status updates at bottom-right corner
  { 'j-hui/fidget.nvim', opts = {} },
}
