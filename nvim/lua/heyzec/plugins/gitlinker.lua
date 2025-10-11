-- Generate web permalinks to files and lines in git repos
return {
  -- Maintained fork of ruifm/gitlinker.nvim
  'linrongbin16/gitlinker.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', cond = true },
  cond = true, -- load this plugin, even in VS Code
  config = function()
    require('gitlinker').setup {
      router = {
        browse = {
          -- Add custom git instances here
        },
      },
    }
  end,
}
