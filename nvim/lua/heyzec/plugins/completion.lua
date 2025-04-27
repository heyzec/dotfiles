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
      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
}
