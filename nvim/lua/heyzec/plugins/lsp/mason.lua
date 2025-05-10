-- Setup mason so it can manage external tooling
-- Use mason-tool-installer to declaratively install

local servers = require("heyzec.utils.lsp").servers

return {
    -- Manage external editor tooling i.e LSP servers
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        -- TODO: Remove neodev, it is deprecated
        "folke/neodev.nvim", -- anotations for neovim api functions
    },
    cmd = "Mason",
    event = "BufReadPre",
    config = function()
        -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
        require('neodev').setup({})

        local mason = require('mason')
        local mason_lspconfig = require('mason-lspconfig')
        local mason_tool_installer = require('mason-tool-installer')

        mason.setup({
            -- Set mason to prefer using system installed program if it's available
            -- https://github.com/williamboman/mason.nvim/issues/428#issuecomment-1357203892
            PATH = "append",
        })

        -- to enable autocompletion (assign to every lsp server config)
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)


        -- Define configs for each specific language here
        mason_lspconfig.setup_handlers({
            -- Default fallback handler for those not explcitly specified
            function(server_name)
                require("lspconfig")[server_name].setup {
                    -- Removed, we config keymaps using the autocmd LspAttach
                    -- on_attach = on_attach,
                    capabilities = capabilities,
                    settings = servers[server_name],
                }
            end,
        })


        mason_tool_installer.setup({
            ensure_installed = {
                'bash-language-server',      -- Bash, LSP, npm
                'shellcheck',                -- Bash, linting, binary (Github)

                -- 'nil',                       -- Nix, LSP, cargo

                'lua-language-server',       -- Lua, LSP, binary (Github)
                'pyright',                   -- Python, LSP, npm

                -- For Mason installed clangd, includes will not work on nixos
                -- Use nixpkgs instead
                -- 'clangd',                    -- C++, LSP, binary (Github)

                -- 'html-lsp',
                -- 'isort',
            }
        })
    end,
    opts = {},
}

