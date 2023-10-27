-- Setup mason so it can manage external tooling

-- require("mason").setup {
--     -- https://github.com/williamboman/mason.nvim/issues/428#issuecomment-1357203892
--     PATH = "append",
-- }
-- Use mason-tool-installer to declaratively install


return {
    -- Manage external editor tooling i.e LSP servers
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "folke/neodev.nvim", -- anotations for neovim api functions
    },
    cmd = "Mason",
    event = "BufReadPre",
    config = function()
        local mason = require('mason')
        local mason_lspconfig = require('mason-lspconfig')
        local mason_tool_installer = require('mason-tool-installer')

        local telescope = require('telescope.builtin')

        mason.setup()
        
        local opts = { }
        local on_attach = function(_, bufnr)
            opts.buffer = bufnr

            opts.desc = "Smart rename"
            vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)

            opts.desc = "Show LSP references"
            vim.keymap.set('n', 'gr', telescope.lsp_references)

            vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })


            vim.keymap.set('n', '<leader>s', telescope.lsp_document_symbols)
            vim.keymap.set('n', '<leader>S', telescope.lsp_dynamic_workspace_symbols)
        end

        -- to enable autocompletion (assign to every lsp server config)
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


        -- Define configs for each specific language here
        mason_lspconfig.setup_handlers({
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
        
    
        mason_tool_installer.setup({
            ensure_installed = {
                'bash-language-server',
                'clangd',
                'html-lsp',
                'isort',
                'lua-language-server',
                'pyright',
                'shellcheck'
            }
        })
    end,
    opts = {},
}
