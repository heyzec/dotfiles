-- ##### LSP #####
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
    function (server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {}
    end,
})
