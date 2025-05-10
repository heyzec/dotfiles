-- Statusline plugin
return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  opts = {
    options = {
      component_separators = '|',
      section_separators = { left = '', right = '' },
      theme = 'codedark',
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = { 'filename' },
      -- encoding means character encoding, e.g. utf-8
      -- fileformat means line ending style, e.g. unix, dos, mac
      lualine_x = { "vim.fn['zoom#statusline']()", 'encoding', 'fileformat', 'filetype', 'lsp_status' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
  },
}
