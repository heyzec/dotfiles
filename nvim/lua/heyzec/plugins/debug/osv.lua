-- Debug lua code and configs running in a Neovim instance
local init_debug = vim.fn.getenv 'NVIM_INIT_DEBUG' ~= vim.NIL
return {
  'jbyuki/one-small-step-for-vimkind',
  priority = 1001,
  -- only enable this plugin with when we are debugging Neovim configs
  cond = init_debug,
  config = function()
    -- Pass a nonempty NVIM_INIT_DEBUG env var to wait for debugger to attach
    if init_debug then
      require('osv').launch { port = 8086, blocking = true }
      vim.cmd.sleep(1) -- without this, breakpoints seem to be not registered fast enough
    end
  end,
}
