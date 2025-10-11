-- This file contains remaps such as
-- - Advanced features that original vim is unable to do, e.g. lsp
-- - vscode-neovim remaps

-- ###############################################################################
-- ##                                                                           ##
-- ##                              1. UTILITIES                                 ##
-- ##                                                                           ##
-- ###############################################################################

local keymap_utils = require 'heyzec.utils.keymaps'
local map_table = keymap_utils.map_table
local action = keymap_utils.create_conditional_action
local bind = keymap_utils.create_bind

-- Create callback that runs a VS Code command
local function vscode(cmd)
  return function()
    require('vscode').action(cmd)
  end
end

-- ###############################################################################
-- ##                                                                           ##
-- ##                             2. DEFINE ACTIONS                             ##
-- ##                                                                           ##
-- ###############################################################################

-- Substitutions
local find_and_replace = action('Find/Replace', ':%s//g<Left><Left>', vscode 'editor.action.startFindReplaceAction')
local find_and_replace_v = action('Find/Replace with selection prefilled', '"zy:%s/<C-r>z//g<Left><Left>')

-- Writing and formatting
local function write()
  local ok, result = pcall(vim.api.nvim_exec2, 'write', { output = true })
  if not ok then
    assert(type(result) == 'string')
    local message = table.concat(vim.iter(string.gmatch(result, '[^:]+')):totable(), ':', 3)
    vim.notify(message, vim.log.levels.ERROR)
    return
  end

  return result.output
end

local function format()
  return require('conform').format { async = true, lsp_format = 'fallback' }
end

local save_or_format = action('Save/Format', function()
  local message = write()
  if message then
    local ok = format()
    if ok then
      message = message .. ' (formatted)'
    end
    vim.notify(message, vim.log.levels.INFO)
  end
end, write)

------------------------2.1. Telescope----------------------
-- See https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#pickers for list

-- Vim Pickers
local find_buffers = action('󰈔 Buffers', '<Cmd>Telescope buffers<CR>')
local find_oldfiles = action(' Oldfiles', '<Cmd>Telescope oldfiles<CR>', vscode 'workbench.action.openRecent')
local find_commands = action('Command History', '<Cmd>Telescope commands<CR>')
local marks = action('Marks', '<Cmd>Telescope marks<CR>')
local jumplist = action('Jumplist', '<Cmd>Telescope jumplist<CR>')
local keymaps = action('Keymaps', '<Cmd>Telescope keymaps<CR>')
local vim_help = action('Help', '<Cmd>Telescope help_tags<CR>')

-- Neovim Pickers
local search_diagnostics = action('Diagnostics', '<Cmd>Telescope diagnostics<CR>', vscode 'workbench.action.view.problems')

-- Find files and Grep
local find_files = action('󰈔 Find files', '<Cmd>Telescope find_files<CR>', vscode 'workbench.action.quickOpen')
-- this requires the Periscope VS Code extension (JoshMu.periscope)
local search_files = action(' Grep files', '<Cmd>Telescope live_grep<CR>', vscode 'periscope.search')
local search_by_word = action(' Grep files by word', '<Cmd>Telescope grep_string<CR>')
local search_vim_configs = action('Neovim Configs', function()
  require('telescope.builtin').live_grep { cwd = vim.fn.stdpath 'config' }
end)

-- Others
local resume = action('Resume', '<Cmd>Telescope resume<CR>')
local undo = action('Undo', function()
  local telescope_ext = require('telescope').extensions
  if telescope_ext.undo then
    telescope_ext.undo.undo()
  end
end, vscode 'workbench.action.localHistory.restoreViaPicker')

------------------------2.2. LSP----------------------------
-- Goto
-- See :help *g* for g-prefixed default keymaps
local goto_def = action('💬 [G]oto [D]efinition', '<Cmd>Telescope lsp_definitions<CR>', vscode 'editor.action.revealDefinition')
local goto_ref = action('💬 Goto [R]eferences', '<Cmd>Telescope lsp_references<CR>', vscode 'editor.action.goToReferences')
local goto_impl = action('💬 Goto [I]mplementation', '<Cmd>Telescope lsp_implementations<CR>', vscode 'editor.action.goToImplementation')
local goto_type_def = action('💬 Goto [T]ype Definition', '<Cmd>Telescope lsp_type_definitions<CR>', vscode 'editor.action.goToTypeDefinition')
local goto_prev_diagnostic = action('💬 Goto Prev Diagnostic', nil, vscode 'editor.action.marker.next')

local goto_next_diagnostic = action('💬 Goto Next Diagnostic', nil, vscode 'editor.action.marker.next')

-- Info
local show_hover = action('💬 Hover', function()
  require('hover').hover()
end, vscode 'editor.action.showHover')
local signature_help = action('💬 Signature Help', vim.lsp.buf.signature_help)

-- Searches
local search_document_symbols = action('💬 Document Symbols', '<Cmd>Telescope lsp_document_symbols<CR>', vscode 'workbench.action.gotoSymbol')
-- unlike builtin.lsp_workspace_symbols, this one updates the filter query to the LSP whenever we type
local search_workspace_symbols = action('💬 Workspace Symbols', '<Cmd>Telescope lsp_dynamic_workspace_symbols<CR>', vscode 'workbench.action.showAllSymbols')

-- Code actions
local code_action = action('💬 Code Action (Quick))', function()
  vim.lsp.buf.code_action { only = { 'quickfix' } }
end, vscode 'editor.action.quickFix')
local code_refactor = action('💬 Code Action (Re[f]actor)', vim.lsp.buf.code_action, vscode 'editor.action.refactor')
local code_rename = action('💬 Code Re[n]ame', vim.lsp.buf.rename, vscode 'editor.action.rename')

local code_format = action('Format Document', format, vscode 'editor.action.formatDocument')

--------------------------2.3. Git----------------------------
-- Git Pickers
local git_commits = action('Git Commits', '<Cmd>Telescope git_commits<CR>')
local git_status = action('Git Status', '<Cmd>Telescope git_status<CR>')

-- Hunk Actions
local git_stage_hunk = action('Stage hunk', '<Cmd>Gitsigns stage_hunk<CR>', vscode 'git.stageSelectedRanges')
local git_unstage_hunk = action('Unstage hunk', '<Cmd>Gitsigns stage_hunk<CR>', vscode 'git.unstageSelectedRanges')
local git_reset_hunk = action('Reset hunk', '<Cmd>Gitsigns reset_hunk<CR>', vscode 'git.revertSelectedRanges')
-- Gitsigns require cursor to be on hunk, while VS Code will jump to next hunk if not on hunk
local git_preview_hunk = action('Preview hunk', '<Cmd>Gitsigns preview_hunk_inline<CR>', vscode 'editor.action.dirtydiff.next')

-- gitlinker.nvim
local cmd = require('gitlinker').link
local git_permalink = action('Get permalink', cmd, cmd)

---------------------2.4. Other Extensions--------------------
-- Neotree
-- If drawer is open, but not focused, don't close, instead focus to it.
-- Benefit: If access wrong file, can tap to go back to nav another file
-- If intention is to close, then just press it again
local explorer = action(
  '🗃️ Toggle Explorer',
  '<Cmd>Neotree reveal<CR>',
  -- Part [1]: If buffer is (1) closed or (2) open but unfocused, open and focus to the explorer
  -- Part [2]: Otherwise, close the panel
  -- Not possible to map here, because keys are not sent to neovim when buffer unfocused.
  -- Refer to map in keybindings.json
  vscode 'workbench.view.explorer'
)

-- Barbar
-- API: https://github.com/romgrk/barbar.nvim/blob/master/lua/barbar/api.lua
local barbar_pin_toggle = action('📌 Pin', '<Cmd>BufferPin<CR>', vscode 'workbench.action.pinEditor')
local barbar_unpin_vscode = action('📌 Pin', nil, vscode 'workbench.action.unpinEditor')
local barbar_pick = action('📌 Pick', '<Cmd>BufferPick<CR>')
local function barbar_goto(n)
  return action('📌 Goto pinned', '<Cmd>BufferGoto ' .. n .. '<CR>')
end

-- Hover
-- Actions to switch panes in the hover popup
local hover_switch_next = action('hover.nvim (next source)', function()
  require('hover').hover_switch 'next'
end)
local hover_switch_prev = action('hover.nvim (prev source)', function()
  require('hover').hover_switch 'previous'
end)

-- Vim Zoom
local zoom = action('Zoom', function()
  vim.call 'zoom#toggle'
end, vscode 'workbench.action.toggleMaximizeEditorGroup')

------------------------2.5. Toggle settings-----------------------

local function toggle(setting_name, namespace)
  if namespace == nil then
    namespace = 'o'
  end
  return action('Toggle ' .. setting_name, function()
    local result = not vim[namespace][setting_name]
    vim[namespace][setting_name] = result
    vim.notify('Toggled ' .. setting_name .. ' to ' .. tostring(result))
  end)
end

local toggle_spell = toggle 'spell'
local toggle_wrap = toggle 'wrap'
local toggle_auto_save = toggle('auto_save', 'g')
local toggle_completion = toggle('completion', 'g')

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
  ['<C-k>'] = bind { 'i', signature_help }, -- overrides default i_<C-k> (insert digraphs)
  ['<C-n>'] = hover_switch_next, -- overrides default <C-n> (down)
  ['<C-p>'] = hover_switch_prev, --overrides default <C-p> (up)

  ['[d'] = goto_prev_diagnostic,
  [']d'] = goto_next_diagnostic,

  ['=='] = code_format,

  ['\\'] = explorer,

  ['<C-w>m'] = zoom,

  ['<leader>'] = {
    ['w'] = save_or_format,

    ['f'] = bind({ 'n', find_and_replace, { silent = false } }, { 'v', find_and_replace_v, { silent = false } }),

    -- Some telescope actions
    ['<leader>'] = find_files,
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
      ['s'] = search_workspace_symbols,
      ['S'] = search_document_symbols,
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
      ['t'] = git_status,
      ['c'] = git_commits,
      ['s'] = git_stage_hunk,
      ['S'] = git_unstage_hunk,
      ['r'] = git_reset_hunk,
      ['p'] = git_preview_hunk,
      ['l'] = git_permalink,
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
      ['c'] = toggle_completion,
    },
  }, -- <leader>
}

map_table(mappings)
