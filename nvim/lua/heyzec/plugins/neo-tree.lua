-- File tree explorer
return {
  'nvim-neo-tree/neo-tree.nvim',
  dependencies = {
    -- hard dependency: lua utilities library (e.g. scanning filesystem)
    'nvim-lua/plenary.nvim',
    -- hard dependency: ui component library
    'MunifTanjim/nui.nvim',
    -- soft dependency for file icons
    -- 'nvim-tree/nvim-web-devicons',
  },
  lazy = false,

  cmd = 'Neotree',
  opts = {
    filesystem = {
      -- check this: https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1247
      -- To open neo-tree when nvim called with a directory
      -- hijack_netrw_behavior = "open_default",
      hijack_netrw_behavior = 'open_current',
    },
    window = {
      mappings = {
        ['\\'] = 'close_window',
        ['P'] = {
          'toggle_preview',
          config = { use_float = false },
        },
      },
    },
  },
}
