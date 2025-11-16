-- File tree explorer
return {
  'nvim-neo-tree/neo-tree.nvim',
  enabled = false,
  dependencies = {
    -- hard dependency: lua utilities library (e.g. scanning filesystem)
    'nvim-lua/plenary.nvim',
    -- hard dependency: ui component library
    'MunifTanjim/nui.nvim',
    -- soft dependency for file icons
    -- 'nvim-tree/nvim-web-devicons',
  },
  lazy = false, -- neo-tree will lazily load itself
  ---@module "neo-tree"
  ---@type neotree.Config?
  opts = {
    filesystem = {
      -- To open neo-tree when nvim called with a directory
      -- See: https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1247
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
    default_component_configs = {
      git_status = {
        symbols = {
          -- Change type
          added = 'A',
          deleted = 'D',
          modified = 'M',
          renamed = 'R',
          -- Status type
          untracked = 'U',
          ignored = '',
          unstaged = '',
          staged = '',
          conflict = '',
        },
      },
    },
  },
}
