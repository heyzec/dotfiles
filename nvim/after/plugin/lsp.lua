-- ##### LSP #####


local on_attach = function(_, bufnr)
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, { buffer = bufnr })
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })

    vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references)
    vim.keymap.set('n', '<leader>s', require('telescope.builtin').lsp_document_symbols)
    vim.keymap.set('n', '<leader>S', require('telescope.builtin').lsp_dynamic_workspace_symbols)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require("mason").setup()
-- Use mason-tool-installer to declaratively install
require('mason-tool-installer').setup {
    ensure_installed = {
        'bash-language-server',
        'clangd',
        'html-lsp',
        'isort',
        'lua-language-server',
        'pyright',
        'shellcheck'
    }
}
require("mason-lspconfig").setup_handlers({
    -- Define configs for each specific language here
    -- ...
    ["lua_ls"] = function()
        require('neodev').setup()
        require("lspconfig").lua_ls.setup {
            on_attach = on_attach,
            capabilities = capabilities,
            Lua = {
                -- Stop prompting
                -- See https://github.com/LunarVim/LunarVim/issues/4049
                workspace = { checkThirdParty = false},
            },
        }
    end,

    -- Default fallback handler for those not explcitly specified
    function (server_name)
        require("lspconfig")[server_name].setup {
            on_attach = on_attach,
            capabilities = capabilities,
        }
    end,
})
