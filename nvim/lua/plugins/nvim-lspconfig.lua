-- required for nvim LSP
return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    -- config = function()
    --     local lspconfig = require('lspconfig')
    --     local mason_lsp_config = require('mason-lspconfig')
    --     local telescope = require('telescope.builtin')

    --     local opts = { }
    --     local on_attach = function(_, bufnr)
    --         opts.buffer = bufnr

    --         opts.desc = "Smart rename"
    --         vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)

    --         opts.desc = "Show LSP references"
    --         vim.keymap.set('n', 'gr', telescope.lsp_references)

    --         vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })


    --         vim.keymap.set('n', '<leader>s', telescope.lsp_document_symbols)
    --         vim.keymap.set('n', '<leader>S', telescope.lsp_dynamic_workspace_symbols)
    --     end

    --     -- to enable autocompletion (assign to every lsp server config)
    --     local capabilities = vim.lsp.protocol.make_client_capabilities()
    --     capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
    -- 
    --     -- Define configs for each specific language here
    --     -- ...
    --     --
    --         -- require('neodev').setup()
    --         -- require("lspconfig").lua_ls.setup {
    --     lspconfig["lua_ls"].setup({
    --         on_attach = on_attach,
    --         capabilities = capabilities,
    --         Lua = {
    --             -- Stop prompting
    --             -- See https://github.com/LunarVim/LunarVim/issues/4049
    --             workspace = { checkThirdParty = false},
    --         },
    --     })

    --     mason_lsp_config.setup_handlers({
    --         -- Default fallback handler for those not explcitly specified
    --         function (server_name)
    --             lspconfig[server_name].setup {
    --                 on_attach = on_attach,
    --                 capabilities = capabilities,
    --             }
    --         end
    --     })

    -- end
}


