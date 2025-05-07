-- Statusline plugin
return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  opts = {
    options = {
      component_separators = '|',
      section_separators = { left = '', right = '' },
      theme = 'codedark',
      -- theme = 'vscode',
    },
    -- laststatus = 3,
    -- -- globalstatus = true,
    -- -- sections = {
    -- --   lualine_a = { 'filename' },
    -- --   lualine_b = { 'branch' },
    -- --   lualine_c = { 'diff' },
    -- --   lualine_x = { 'diagnostics' },
    -- --   lualine_y = { 'filetype' },
    -- --   lualine_z = { 'location' },
    -- -- },
    -- -- inactive_winbar = {
    -- --   lualine_a = { 'filename' },
    -- --   lualine_b = { 'branch' },
    -- --   lualine_c = { 'diff' },
    -- --   lualine_x = { 'diagnostics' },
    -- --   lualine_y = { 'filetype' },
    -- --   lualine_z = { 'location' },
    -- -- },
    -- winbar = {
    --   lualine_a = { 'filename' },
    --   lualine_b = { 'branch' },
    --   lualine_c = { 'diff' },
    --   lualine_x = { 'diagnostics' },
    --   lualine_y = { 'filetype' },
    --   lualine_z = { 'location' },
    -- },
  },
}
