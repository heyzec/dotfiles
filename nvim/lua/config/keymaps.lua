-- This file contains remaps such as
-- - Advanced features that original vim is unable to do, e.g. lsp
-- - vscode-neovim remaps

-- ###############################################################################
-- ##                                                                           ##
-- ##                              1. UTILITIES                                 ##
-- ##                                                                           ##
-- ###############################################################################

local map_table = require('utils.keymap').map_table
local action = require('utils.keymap').create_action
local bind = require('utils.keymap').create_bind

-- Create a callback that runs a vscode command
local vscode = function(cmd)
    return function()
        require('vscode-neovim').call(cmd)
    end
end

local telescope
local telescope_ext
local hover
local barbar
if not vim.g.vscode then
    telescope     = require('telescope.builtin')
    telescope_ext = require('telescope').extensions
    hover         = require('hover')
    barbar        = require('barbar.api')
else
    -- Hack to avoid having to use index error when doing telescope.find_files
    telescope     = {}
    telescope_ext = nil
    hover         = {}
    barbar        = {}
end

-- From vimrc
if vim.g.vscode then
    vim.keymap.set('n', '<leader>w', vscode('workbench.action.files.save'))
    vim.keymap.set('n', '<leader>s', vscode('editor.action.startFindReplaceAction'))
end


-- ###############################################################################
-- ##                                                                           ##
-- ##                             2. DEFINE ACTIONS                             ##
-- ##                                                                           ##
-- ###############################################################################

------------------------2.1. Telescope----------------------
-- See https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#pickers for list

-- File Pickers
local find_files = action("🔭 Find files", telescope.find_files, vscode('workbench.action.quickOpen'))
local grep_files = action("🔭 Grep files", telescope.live_grep, vscode('workbench.action.showAllSymbols'))


-- Vim Pickers
local buffers           = action("🔭 Buffers", telescope.buffers)
local oldfiles          = action("🔭 Oldfiles", telescope.oldfiles)
local commands          = action("🔭 Command History", telescope.commands)
local marks             = action("🔭 Marks", telescope.marks)
local jumplist          = action("🔭 Jumplist", telescope.jumplist)
local keymaps           = action("🔭 Keymaps", telescope.keymaps)
local resume            = action("🔭 Resume", telescope.resume)

-- Neovim LSP Pickers (non gotos)
local diagnostics       = action("🔭 Diagnostics", telescope.diagnostics, vscode('workbench.action.view.problems'))
local document_symbols  = action("🔭 Symbols", telescope.lsp_document_symbols)
local workspace_symbols = action("🔭 Symbols", telescope.lsp_workspace_symbols)

-- Git Pickers
local git_commits       = action("🔭 Git Commits", telescope.git_commits)
local git_status        = action("🔭 Git Status", telescope.git_status)

-- Extensions
local undo              = action("🔭 Undo", function() if telescope_ext then telescope_ext.undo.undo() end end)


------------------------2.2. LSP----------------------------
-- Goto
-- See :help *g* for g-prefixed default keymaps
local goto_def       = action('💬 [G]oto [D]efinition', telescope.lsp_definitions,
    vscode('editor.action.revealDefinition'))
local goto_ref       = action('💬 [G]oto [R]eferences', telescope.lsp_references, vscode('editor.action.goToReferences'))
local goto_impl      = action('💬 [G]oto [I]mplementation', telescope.lsp_implementations,
    vscode('editor.action.goToImplementation'))
local goto_type_def  = action('💬 [G]oto [T]ype Definition', telescope.lsp_type_definitions,
    vscode('editor.action.goToTypeDefinition'))

-- Info
local show_hover          = action('💬 Hover', hover.hover, vscode('editor.action.showHover'))
local signature_help = action('💬 Signature Help', vim.lsp.buf.signature_help)

-- Actions
local code_action    = action('💬 [C]ode [A]ction (Quick))',
    function()
        vim.lsp.buf.code_action({ only = { "quickfix" } })
    end,
    vscode('editor.action.quickFix'))
local code_refactor  = action('💬 [C]ode Action', vim.lsp.buf.code_action, vscode('editor.action.refactor'))
local code_rename    = action('💬 [C]ode Smart Rename', vim.lsp.buf.rename, vscode('editor.action.rename'))
local code_format    = action('💬 Format Document',
    function()
        vim.lsp.buf.format { async = true }
    end,
    vscode('editor.action.formatDocument'))

------------------------2.3. Extensions-----------------------
-- Neotree
local explorer       = action('🗃️ Toggle Explorer',
    function()
        -- If drawer is open, but not focused, don't close. instead focus to it
        -- Benefit: If access wrong file, can tap to go back to nav another file
        -- If intention is to close, then just press it again
        if (string.find(vim.api.nvim_buf_get_name(0), "tree") ~= nil) then
            vim.cmd("Neotree toggle")
        else
            vim.cmd("Neotree focus")
        end
    end,
    -- Part [1]: If buffer is (1) closed or (2) open but unfocused, open and focus to the explorer
    -- Part [2]: Otherwise, close the panel
    -- Not possible to map here, because keys are not sent to neovim when buffer unfocused.
    -- Refer to map in keybindings.json
    vscode('workbench.view.explorer'))

-- Barbar
-- API: https://github.com/romgrk/barbar.nvim/blob/master/lua/barbar/api.lua
local barbar_pin     = action("📌 Pin", function() vim.cmd("BufferPin") end)
local barbar_pick    = action("📌 Pick", function() barbar.pick_buffer() end)
local function barbar_goto(n)
    return action("📌 Goto pinned", function() barbar.goto_buffer(n) end)
end

-- Hover
-- Actions to switch panes in the hover popup
---@diagnostic disable-next-line: missing-parameter
local hover_switch_next = action("hover.nvim (next source)", function() hover.hover_switch("next") end)
---@diagnostic disable-next-line: missing-parameter
local hover_switch_prev = action("hover.nvim (prev source)", function() hover.hover_switch("previous") end)



-- ###############################################################################
-- ##                                                                           ##
-- ##                             3. DEFINE MAPPINGS                            ##
-- ##                                                                           ##
-- ###############################################################################
local mappings = {
    ['g'] = {
        ['d'] = goto_def,  -- overrides default gd (goto local declaration)
        ['r'] = goto_ref,  -- overrides default gr (replace virtual characters)
        ['I'] = goto_impl, -- overrides default gI (insert text in column 1)
        ['y'] = goto_type_def,
    },

    ['K'] = show_hover,                         -- overrides default K (to lookup word on cursor)
    ['gK'] = signature_help,
    ['<C-k>'] = bind('i', signature_help), -- overrides default i_<C-k> (insert digraphs)

    ['<C-n>'] = hover_switch_next,         -- overrides default <C-n> (down)
    ['<C-p>'] = hover_switch_prev,         --overrides default <C-p> (up)

    ['gO'] = document_symbols,             -- overrides default gO (outline of buffer for man, help)

    ['=='] = code_format,

    ['<leader>'] = {
        ['<space>'] = find_files,
        ['/'] = grep_files,
        [':'] = commands,

        ['e'] = explorer,

        -- More useful ones
        ['o'] = oldfiles,
        ['r'] = resume,

        -- Barbar as harpoon
        ["h"] = {
            'harpoon',
            ["a"] = barbar_pin,
            ["p"] = barbar_pick,
        },

        ['f'] = {
            '🔭 Find using Telescope',
            ['r'] = resume,
            ['o'] = oldfiles,
            ['u'] = undo,

            ['b'] = buffers,
            ['e'] = diagnostics,
            ['j'] = jumplist,
            ['k'] = keymaps,
            ['m'] = marks,
        },

        ['s'] = {
            'search',
            ['s'] = document_symbols,
            ['S'] = workspace_symbols,
        },

        ['c'] = {
            '💬 code',
            ['a'] = code_action,
            ['f'] = code_refactor,
            ['r'] = code_rename,
        },

        ['g'] = {
            'git',
            ['s'] = git_status,
            ['c'] = git_commits,
        },

        -- Use barbar to quickly switch "tabs" like Harpoon
        ["1"] = barbar_goto(1),
        ["2"] = barbar_goto(2),
        ["3"] = barbar_goto(3),
        ["4"] = barbar_goto(4),
        ["5"] = barbar_goto(5),
        ["6"] = barbar_goto(6),
        ["7"] = barbar_goto(7),
        ["8"] = barbar_goto(8),
        ["9"] = barbar_goto(9),
    },
}

map_table(mappings)

-- Use LspAttach autocommand to create buffer local mappings
-- after the language server attaches to the current buffer
-- See https://github.com/neovim/nvim-lspconfig#suggested-configuration
-- See `:help vim.lsp.*` for documentation on any of the below functions
-- vim.api.nvim_create_autocmd('LspAttach', {
--     group = vim.api.nvim_create_augroup('UserLspConfig', {}),
--     callback = function(ev)
--         local map = function(keys, callback, desc, extra)
--             local opts = extra or {}
--             opts.buffer = ev.buf
--             opts.desc = desc and 'LSP: ' .. desc
--
--             utils_map(keys, callback, opts)
--         end
--
--         -- Insert your buffer local mappings here
--     end,
-- })
