-- Autoformat files
return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  --- @module 'conform'
  --- @type conform.setupOpts
  opts = {
    formatters_by_ft = require('heyzec.utils.tooling').get_formatters_config(),
  },
}
