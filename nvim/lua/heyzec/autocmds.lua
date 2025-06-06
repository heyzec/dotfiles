-----------------------------------------------------------
-- Return cursor position
-----------------------------------------------------------
-- See `:help last-position-jump`
vim.api.nvim_create_autocmd('BufRead', {
  desc = 'Return to last edit position when opening files',
  group = vim.api.nvim_create_augroup('RestoreCursor', {}),
  callback = function()
    local ft = vim.opt_local.filetype:get()
    -- don't apply to git messages
    if ft == 'gitcommit' or ft == 'gitrebase' then
      return
    end
    -- get position of last saved edit
    local markpos = vim.api.nvim_buf_get_mark(0, '"')
    local line, col = markpos[1], markpos[2]
    -- if in range, go there
    if line > 1 and line <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, { line, col })
    end
  end,
})

-----------------------------------------------------------
-- Highlight on yank
-----------------------------------------------------------
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('YankHighlight', {}),
  callback = function()
    vim.highlight.on_yank { timeout = 800 }
  end,
})

-----------------------------------------------------------
-- Change line number based on mode
-----------------------------------------------------------
-- from https://github.com/dmxk062/dotfiles/blob/main/.config/nvim/lua/modules/autocommands.lua
-- for command mode: make it absolute for ranges etc
-- for normal mode: relative movements <3
local cmdline_group = vim.api.nvim_create_augroup('CmdlineLinenr', {})
-- debounce cmdline enter events to make sure we don't have flickering for non user cmdline use
-- e.g. mappings using : instead of <Cmd>
local cmdline_debounce_timer

vim.api.nvim_create_autocmd('CmdlineEnter', {
  group = cmdline_group,
  callback = function()
    cmdline_debounce_timer = vim.uv.new_timer()
    ---@diagnostic disable-next-line: need-check-nil
    cmdline_debounce_timer:start(
      100,
      0,
      vim.schedule_wrap(function()
        if vim.o.number then
          vim.o.relativenumber = false
          vim.api.nvim__redraw { statuscolumn = true }
        end
      end)
    )
  end,
})

vim.api.nvim_create_autocmd('CmdlineLeave', {
  group = cmdline_group,
  callback = function()
    if cmdline_debounce_timer then
      cmdline_debounce_timer:stop()
      cmdline_debounce_timer = nil
    end
    if vim.o.number then
      vim.o.relativenumber = true
    end
  end,
})

-----------------------------------------------------------
-- Document highlight on cursor hold
-----------------------------------------------------------
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end
  end,
})
