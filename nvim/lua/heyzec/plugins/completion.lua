return {
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
      },
      completion = {
        menu = {
          border = 'rounded',
          draw = {
            columns = {
              { 'label' },
              { 'label_description', 'kind_icon', gap = 10 },
              { 'kind' },
            },
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
          menu = { auto_show = true },
          list = { selection = { preselect = false } },
        },
      },
    },
  },
}
