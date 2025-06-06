-- Provides auto-completion
return {
  'saghen/blink.cmp',
  event = 'InsertEnter',
  -- use a release tag to download pre-built binaries
  version = '1.*',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- keymaps:
    -- - 'default' for mappings similar to vim built-in completion
    -- - 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- - 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    keymap = {
      preset = 'default',
      ['<CR>'] = { 'accept', 'fallback' },
    },
    completion = {
      list = { selection = { preselect = false, auto_insert = true } },
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
    sources = {
      providers = {
        -- buffer source tends to trigger unhelpfully esp. in config files, we tweak this below
        buffer = {
          max_items = 3, -- default of nil (no limit)
          min_keyword_length = 3, -- default of 1
        },
      },
    },
    -- show function signature while typing arguments
    signature = { -- experimental
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
    enabled = function()
      return vim.g.completion
    end,
  },
}
