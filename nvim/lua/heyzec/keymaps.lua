-- This file contains remaps such as
-- - Advanced features that original vim is unable to do, e.g. lsp
-- - vscode-neovim remaps

-- ###############################################################################
-- ##                                                                           ##
-- ##                              1. UTILITIES                                 ##
-- ##                                                                           ##
-- ###############################################################################

local keymap_utils = require 'heyzec.utils.keymaps'
local prequire = keymap_utils.prequire
local map_table = keymap_utils.map_table
local action = keymap_utils.create_conditional_action
local bind = keymap_utils.create_bind

-- Create callback that runs a VS Code command
local function vscode(cmd)
  return function()
    require('vscode-neovim').call(cmd)
  end
end

local telescope = {}
local telescope_ext = {}
local hover = {}
local barbar = {}
if not vim.g.vscode then
  telescope = prequire 'telescope.builtin'
  telescope_ext = prequire('telescope').extensions
  hover = prequire 'hover'
  barbar = prequire 'barbar.api'
end

-- From vimrc
if vim.g.vscode then
  vim.keymap.set('n', '<leader>s', vscode 'editor.action.startFindReplaceAction')
end

-- ###############################################################################
-- ##                                                                           ##
-- ##                             2. DEFINE ACTIONS                             ##
-- ##                                                                           ##
-- ###############################################################################

local function format()
  require('conform').format { async = true, lsp_format = 'fallback' }
end

local save_or_format = action('Save/Format', format, vscode 'workbench.action.files.save')

------------------------2.1. Telescope----------------------
-- See https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#pickers for list

-- Vim Pickers
local find_buffers = action('󰈔 Buffers', telescope.buffers)
local find_oldfiles = action(' Oldfiles', telescope.oldfiles, vscode 'workbench.action.openRecent')
local find_commands = action('Command History', telescope.commands)
local marks = action('Marks', telescope.marks)
local jumplist = action('Jumplist', telescope.jumplist)
local keymaps = action('Keymaps', telescope.keymaps)
local vim_help = action('Help', telescope.help_tags)

-- Neovim Pickers
local search_diagnostics = action('Diagnostics', telescope.diagnostics, vscode 'workbench.action.view.problems')

-- Find files and Grep
local find_files = action('󰈔 Find files', telescope.find_files, vscode 'workbench.action.quickOpen')
local search_files = action(' Grep files', telescope.live_grep, vscode 'workbench.action.showAllSymbols')
local search_by_word = action(' Grep files', telescope.grep_string)
local search_vim_configs = action('Neovim Configs', function()
  telescope.live_grep { cwd = vim.fn.stdpath 'config' }
end)

-- Git Pickers
local git_commits = action('󰊢 Git Commits', telescope.git_commits)
local git_status = action('󰊢 Git Status', telescope.git_status)

-- Others
local resume = action('Resume', telescope.resume)
local undo = action('Undo', function()
  if telescope_ext.undo then
    telescope_ext.undo.undo()
  end
end, vscode 'workbench.action.localHistory.restoreViaPicker')

------------------------2.2. LSP----------------------------
-- Goto
-- See :help *g* for g-prefixed default keymaps
local goto_def = action('💬 [G]oto [D]efinition', telescope.lsp_definitions, vscode 'editor.action.revealDefinition')
local goto_ref = action('💬 Goto [R]eferences', telescope.lsp_references, vscode 'editor.action.goToReferences')
local goto_impl = action('💬 Goto [I]mplementation', telescope.lsp_implementations, vscode 'editor.action.goToImplementation')
local goto_type_def = action('💬 Goto [T]ype Definition', telescope.lsp_type_definitions, vscode 'editor.action.goToTypeDefinition')
local goto_prev_diagnostic = action('💬 Goto Prev Diagnostic', vim.diagnostic.goto_prev, vscode 'editor.action.marker.next')
local goto_next_diagnostic = action('💬 Goto Next Diagnostic', vim.diagnostic.goto_next, vscode 'editor.action.marker.next')

-- Info
local show_hover = action('💬 Hover', hover.hover, vscode 'editor.action.showHover')
local signature_help = action('💬 Signature Help', vim.lsp.buf.signature_help)

-- Searches
local search_document_symbols = action('💬 Document Symbols', telescope.lsp_document_symbols, vscode 'workbench.action.gotoSymbol')
local search_workspace_symbols = action('💬 Workspace Symbols', telescope.lsp_workspace_symbols, vscode 'workbench.action.showAllSymbols')

-- Code actions
local code_action = action('💬 Code Action (Quick))', function()
  vim.lsp.buf.code_action { only = { 'quickfix' } }
end, vscode 'editor.action.quickFix')
local code_refactor = action('💬 Code Action (Re[f]actor)', vim.lsp.buf.code_action, vscode 'editor.action.refactor')
local code_rename = action('💬 Code Re[n]ame', vim.lsp.buf.rename, vscode 'editor.action.rename')

local code_format = action('Format Document', format, vscode 'editor.action.formatDocument')

------------------------2.3. Extensions-----------------------
-- Neotree
-- If drawer is open, but not focused, don't close, instead focus to it.
-- Benefit: If access wrong file, can tap to go back to nav another file
-- If intention is to close, then just press it again
local explorer = action(
  '🗃️ Toggle Explorer',
  function()
    vim.cmd 'Neotree reveal'
  end,
  -- Part [1]: If buffer is (1) closed or (2) open but unfocused, open and focus to the explorer
  -- Part [2]: Otherwise, close the panel
  -- Not possible to map here, because keys are not sent to neovim when buffer unfocused.
  -- Refer to map in keybindings.json
  vscode 'workbench.view.explorer'
)

-- Barbar
-- API: https://github.com/romgrk/barbar.nvim/blob/master/lua/barbar/api.lua
local barbar_pin_toggle = action('📌 Pin', function()
  vim.cmd 'BufferPin'
end, vscode 'workbench.action.pinEditor')
local barbar_unpin_vscode = action('📌 Pin', nil, vscode 'workbench.action.unpinEditor')
local barbar_pick = action('📌 Pick', barbar.pick_buffer)
local function barbar_goto(n)
  return action('📌 Goto pinned', function()
    barbar.goto_buffer(n)
  end)
end

-- Hover
-- Actions to switch panes in the hover popup
local hover_switch_next = action('hover.nvim (next source)', function()
  hover.hover_switch 'next'
end)
local hover_switch_prev = action('hover.nvim (prev source)', function()
  hover.hover_switch 'previous'
end)

------------------------2.4. Toggle settings-----------------------

local function toggle(setting_name, namespace)
  if namespace == nil then
    namespace = 'o'
  end
  return action('Spell', function()
    local result = not vim[namespace][setting_name]
    vim[namespace][setting_name] = result
    vim.notify('Toggled ' .. setting_name .. ' to ' .. tostring(result))
  end)
end

local toggle_spell = toggle 'spell'
local toggle_wrap = toggle 'wrap'
local toggle_auto_save = toggle('auto_save', 'g')

-- ###############################################################################
-- ##                                                                           ##
-- ##                             3. DEFINE MAPPINGS                            ##
-- ##                                                                           ##
-- ###############################################################################
local mappings = {
  ['g'] = {
    ['d'] = goto_def, -- overrides default gd (goto local declaration)
    ['y'] = goto_type_def,

    -- In future Neovim versions, these keymaps will become defaults
    ['rn'] = code_rename,
    ['ra'] = code_action,
    ['rr'] = goto_ref,
    ['ri'] = goto_impl,
    ['O'] = search_document_symbols,
  },

  ['K'] = show_hover, -- overrides default K (lookup word on cursor)
  ['gK'] = signature_help,
  ['<C-k>'] = bind('i', signature_help), -- overrides default i_<C-k> (insert digraphs)
  ['<C-n>'] = hover_switch_next, -- overrides default <C-n> (down)
  ['<C-p>'] = hover_switch_prev, --overrides default <C-p> (up)

  ['[d'] = goto_prev_diagnostic,
  [']d'] = goto_next_diagnostic,

  ['=='] = code_format,

  ['\\'] = explorer,

  ['<leader>'] = {
    ['w'] = save_or_format,

    -- Some telescope actions
    ['<space>'] = find_files,
    ['/'] = search_files,
    [':'] = find_commands,
    ['.'] = find_oldfiles,
    ['r'] = resume,

    -- Barbar as harpoon
    ['h'] = {
      '📌 harpoon',
      ['a'] = barbar_pin_toggle,
      ['A'] = barbar_unpin_vscode,
      ['p'] = barbar_pick,
    },

    ['s'] = {
      ' search',
      ['b'] = find_buffers,
      ['e'] = search_diagnostics,
      ['f'] = find_files,
      ['g'] = search_files,
      ['j'] = jumplist,
      ['h'] = vim_help,
      ['k'] = keymaps,
      ['m'] = marks,
      ['o'] = find_oldfiles,
      ['s'] = search_document_symbols,
      ['S'] = search_workspace_symbols,
      ['v'] = search_vim_configs,
      ['w'] = search_by_word,
      ['u'] = undo,
    },

    ['c'] = {
      -- { 'code', icon = ' ' },
      ['f'] = code_refactor,
    },

    ['g'] = {
      '󰊢 git',
      ['s'] = git_status,
      ['c'] = git_commits,
    },

    -- Use barbar to quickly switch "tabs" like Harpoon
    ['1'] = barbar_goto(1),
    ['2'] = barbar_goto(2),
    ['3'] = barbar_goto(3),
    -- ['4'] = barbar_goto(4),
    -- ['5'] = barbar_goto(5),
    -- ['6'] = barbar_goto(6),
    -- ['7'] = barbar_goto(7),
    -- ['8'] = barbar_goto(8),
    -- ['9'] = barbar_goto(9),

    -- 2.4. Settings
    ['t'] = {
      ['s'] = toggle_auto_save,
      ['w'] = toggle_wrap,
      ['z'] = toggle_spell,
    },
  }, -- <leader>
}

map_table(mappings)
