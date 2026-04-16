-- Better integration of Treesitter for language-aware features, e.g. improved syntax highlighting

-- Disable modules on large buffers
local should_disable = function(ctx, notify)
  local bufnr
  if type(ctx) == 'number' then
    bufnr = ctx
  else
    bufnr = ctx.buf
  end
  local MAX_FILESIZE = 100 * 1024 -- 100 KB
  local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
  local disable = ok and stats and stats.size > MAX_FILESIZE
  if disable and not notify then
    vim.notify('Disabling Treesitter for large buffer: ' .. vim.api.nvim_buf_get_name(bufnr), vim.log.levels.WARN, { title = 'nvim-treesitter' })
  end
  return disable
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    cond = true, -- load this plugin, even in VS Code
    branch = 'main',
    -- update parsers when lazy.nvim updates this plugin
    build = ':TSUpdate',
    event = 'VeryLazy',
  },
  {
    -- Wrapper plugin after nvim-treesitter rewrite
    'MeanderingProgrammer/treesitter-modules.nvim',
    cond = true, -- load this plugin, even in VS Code
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ---@module 'treesitter-modules'
    ---@type ts.mod.UserConfig
    opts = {
      -- install these parsers (nvim-treesitter says these must be needed!)
      ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query', 'markdown', 'markdown_inline' },
      auto_install = true,

      -- ========== Configure builtin modules ==========
      -- 1. Syntax highlighting
      highlight = {
        enable = true,
        disable = should_disable,
      },

      -- 2. Incremental selection
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<C-Space>',
          node_incremental = '<C-Space>',
          scope_incremental = false,
          node_decremental = '<BS>',
        },
      },
      -- 3. Indenting
      indent = { enable = true },
      -- 4. Folding (configured separately, not via opts)
    },
  },
  {
    -- Show context of the current function
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    ---@module 'treesitter-context'
    ---@type TSContext.UserConfig
    opts = {
      mode = 'cursor',
      max_lines = 3,
      on_attach = function(bufnr) -- false to disable
        return not should_disable(bufnr, true)
      end,
    },
  },
}
