-- This file contains remaps such as
-- - Advanced features that original vim is unable to do, e.g. lsp
-- - vscode-neovim remaps

-- ###############################################################################
-- ##                                                                           ##
-- ##                              1. UTILITIES                                 ##
-- ##                                                                           ##
-- ###############################################################################

local utils_map = require('utils.keymap').map
local utils_mapdesc = require('utils.keymap').mapdesc

-- Create a callback that runs a vscode command
local vscode = function(cmd)
    return function()
        require('vscode-neovim').call(cmd)
    end
end

-- Select callback based on whether neovim is embedded in vscode
local conditional = function(normal_callback, vscode_callback)
    if not vim.g.vscode then
        return normal_callback
    else
        return vscode_callback
    end
end

-- From vimrc
if vim.g.vscode then
    vim.keymap.set('n', '<leader>w', vscode('workbench.action.files.save'))
    vim.keymap.set('n', '<leader>s', vscode('editor.action.startFindReplaceAction'))
end


-- ###############################################################################
-- ##                                                                           ##
-- ##                                2. TELESCOPE                               ##
-- ##                                                                           ##
-- ###############################################################################

if not vim.g.vscode then
    local whichkey = require("which-key")
    whichkey.register({ ["<leader>"] = {
        f = { name = "Find using Telescope" },
    } })
end

local telescope
if not vim.g.vscode then
    telescope = require('telescope.builtin')
end

utils_mapdesc(
    '<leader>ff',
    conditional(telescope and telescope.find_files, vscode('workbench.action.quickOpen')),
    "Telescope find files")
utils_mapdesc('<leader>fg',
    conditional(telescope and telescope.live_grep, vscode('workbench.action.showAllSymbols')),
    "Telescope live grep")
utils_mapdesc('<leader>fd',
    conditional(telescope and telescope.diagnostics, vscode('workbench.actions.view.problems')),
    "Telescope diagnostics")

if not vim.g.vscode then
    utils_mapdesc('<leader>fr',  telescope.resume,  "Telescope resume")
    utils_mapdesc('<leader>fm', telescope.marks,    "Telescope marks")
    utils_mapdesc('<leader>fk', telescope.keymaps,  "Telescope keymaps")
    utils_mapdesc('<leader>fu', require('telescope').extensions.undo.undo, "Telescope undo")
    utils_mapdesc('<leader>fj', telescope.jumplist, "Telescope jumplist")
    utils_mapdesc('<leader>fb', telescope.buffers,  "Telescope buffers")
    utils_mapdesc('<leader>fo', telescope.oldfiles,  "Telescope oldfiles")
end


-- ###############################################################################
-- ##                                                                           ##
-- ##                                  3. LSP                                   ##
-- ##                                                                           ##
-- ###############################################################################

-- ----------------------------Info----------------------------
-- overrides vim default mapping of K
utils_mapdesc(
    'K',
    conditional(vim.lsp.buf.hover, vscode('editor.action.showHover')),
    'LSP: Hover')

-- ----------------------------Goto----------------------------
-- See :help *g* for g-prefixed default keymaps
utils_mapdesc(
    '<leader>gd',
    conditional(telescope.lsp_definitions, vscode('editor.action.revealDefinition')),
    'LSP: [G]oto [D]efinition')
utils_mapdesc(
    '<leader>gr',
    conditional(telescope.lsp_references, vscode('editor.action.goToReferences')),
    'LSP: [G]oto [R]eferences')
utils_mapdesc(
    '<leader>gt',
    conditional(telescope.lsp_type_definitions, vscode('editor.action.goToTypeDefinition')),
    'LSP: [G]oto [T]ype definition')
utils_mapdesc(
    '<leader>gi',
    conditional(telescope.lsp_implementations, vscode('editor.action.goToImplementation')),
    'LSP: [G]oto [I]mplementation')

-- ----------------------------Code editing----------------------------
utils_mapdesc(
    '<leader>ca',
    conditional(
        function()
            vim.lsp.buf.code_action({ only = {"quickfix"} })
        end,
        vscode('editor.action.quickFix')),
    'LSP: [C]ode [A]ction')
utils_mapdesc(
    '<leader>cf',
    conditional(vim.lsp.buf.code_action, vscode('editor.action.refactor')),
    'LSP: [C]ode Re[f]actor')
utils_mapdesc(
    '<leader>cr',
    conditional(vim.lsp.buf.rename, vscode('editor.action.rename')),
    'LSP: [C]ode Smart [R]ename')
utils_mapdesc(
    '==',
    conditional(
        function()
            vim.lsp.buf.format { async = true }
        end,
        vscode('editor.action.formatDocument')),
    'LSP: Format Document')

-- Use LspAttach autocommand to create buffer local mappings
-- after the language server attaches to the current buffer
-- See https://github.com/neovim/nvim-lspconfig#suggested-configuration
-- See `:help vim.lsp.*` for documentation on any of the below functions
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local map = function(keys, callback, desc, extra)
            local opts = extra or {}
            opts.buffer = ev.buf
            opts.desc = desc and 'LSP: ' .. desc

            utils_map(keys, callback, opts)
        end

        -- Insert your buffer local mappings here
    end,
})


-- ###############################################################################
-- ##                                                                           ##
-- ##                             4. TOGGLE SIDEPANE                            ##
-- ##                                                                           ##
-- ###############################################################################

-- neotree = require('neo-tree.command')
vim.keymap.set('n', '<leader>e', conditional(
    function()
        -- If drawer is open, but not focused, don't close. instead focus to it
        -- Benefit: If access wrong file, can tap to go back to nav another file
        -- If intention is to close, then just press it again
        if (string.find(vim.api.nvim_buf_get_name(0), "tree") ~= nil) then
            vim.cmd(":Neotree toggle")
        else
            vim.cmd(":Neotree focus")
        end
    end,
    -- Part [1]: If buffer is (1) closed or (2) open but unfocused, open and focus to the explorer
    -- Part [2]: Otherwise, close the panel
    -- Not possible to map here, because keys are not sent to neovim when buffer unfocused.
    -- Refer to map in keybindings.json
    vscode('workbench.view.explorer')))

