return {
  'linrongbin16/gitlinker.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', cond = true },
  cond = true, -- load this plugin, even in VS Code
  config = function()
    require('gitlinker').setup {
      router = {
        browse = {
          ['git%.garena%.com'] = require('gitlinker.routers').github_browse,
        },
      },
    }
  end,
}
