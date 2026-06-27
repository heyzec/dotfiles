return {
  'zhisme/copy_with_context.nvim',
  event = 'VeryLazy',
  cond = true, -- load this plugin, even in VS Code
  opts = {
    -- Customize mappings
    mappings = {
      relative = '<leader>cy',
      absolute = '<leader>cY',
      remote = '<leader>cr',
    },
    formats = {
      default = '# {filepath}:{line}', -- Used by relative and absolute mappings
      remote = '# {remote_url}',
    },
    -- whether to trim lines or not
    trim_lines = false,
  },
}
