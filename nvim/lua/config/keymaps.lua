-- This file contains remaps such as
-- - Advanced features that original vim is unable to do, e.g. lsp
-- - vscode-neovim remaps


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
    utils_mapdesc('<leader>g',  telescope.resume,   "Telescope resume")
    utils_mapdesc('<leader>fm', telescope.marks,    "Telescope marks")
    utils_mapdesc('<leader>fk', telescope.keymaps,  "Telescope keymaps")
    utils_mapdesc('<leader>fu', require('telescope').extensions.undo.undo, "Telescope undo")
    utils_mapdesc('<leader>fj', telescope.jumplist, "Telescope jumplist")
    utils_mapdesc('<leader>fb', telescope.buffers,  "Telescope buffers")
    utils_mapdesc('<leader>fo', telescope.oldfiles,  "Telescope oldfiles")
end

-- Code suggestions
if not vim.g.vscode then
else
    vim.keymap.set('n', '<leader>ca', vscode('editor.action.quickFix'))
    vim.keymap.set('n', '<leader>cr', vscode('editor.action.refactor'))
end




-- neotree = require('neo-tree.command')
vim.keymap.set('n', '<leader>e', conditional(
    function()
        -- If drawer is open, but not focused, don;t close. instead focus to it
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


        -- Jump related
        map('gD',     vim.lsp.buf.declaration,     '[G]oto [D]eclaration')
        map('gd',     vim.lsp.buf.definition,      '[G]oto [D]eclaration')
        map('gi',     vim.lsp.buf.implementation,  '[G]oto [I]mplementation')
        map('gr',     vim.lsp.buf.references,      '[G]oto [R]eferences')
        map('g<C-d>', vim.lsp.buf.type_definition, '[G]oto Type [D]efinition')


        -- Help related
        map('K',  vim.lsp.buf.hover,          'Hover Documentation')
        -- nmap('<C-k>', vim.lsp.buf.signature_help, opts)


        -- Refactor related
        map('<F2>', vim.lsp.buf.rename, 'Smart rename')

        map('<space>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { mode = { 'n', 'v' }})






        -- Others
        -- nmap('<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        -- nmap('<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        -- nmap('<space>wl', function()
        --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        -- end, opts)

        map('==', function()
          vim.lsp.buf.format { async = true }
        end)
    end,
})

