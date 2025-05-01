return {
  'nvim-neo-tree/neo-tree.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    -- -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  -- keys = {
  --   -- TODO: this key should use Neotree if install, else fallback to Lexplore
  --   { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  -- },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
