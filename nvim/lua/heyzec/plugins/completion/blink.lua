return {
  'saghen/blink.cmp',
  -- event = 'VimEnter',
  lazy = false,
  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'default',
      ['<CR>'] = { 'accept', 'fallback' },
    },
    completion = {
      list = { selection = { preselect = false, auto_insert = false } },
      menu = {
        border = 'rounded',
        draw = {
          gap = 1,
          columns = { { 'kind_icon' }, { 'label', 'label_description', 'source_name', gap = 4 } },
          treesitter = { 'lsp' }, -- use treesitter to highlight LSP sources
        },
      },
      documentation = {
        auto_show = true,
        window = { border = 'rounded' },
      },
    },
    -- show function signature while typing arguments
    signature = {
      enabled = true,
      window = { border = 'rounded' },
    },
    cmdline = {
      keymap = {
        ['<Tab>'] = { 'show', 'select_next' },
        ['<S-Tab>'] = { 'select_prev' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<Up>'] = { 'select_prev', 'fallback' },
      },
      completion = {
        list = { selection = { preselect = false, auto_insert = true } },
        menu = { auto_show = true },
      },
    },
  },
}
