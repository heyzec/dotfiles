return {
    -- Provide code completion menu
    "hrsh7th/nvim-cmp", -- Autocompletion
    dependencies = {
        -- Engine
        'L3MON4D3/LuaSnip',
        'saadparwaiz1/cmp_luasnip', -- integrates luasnip with cmp

        -- Completion
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",

        -- Snippets
        'rafamadriz/friendly-snippets',

        "hrsh7th/cmp-nvim-lsp",

        "onsails/lspkind.nvim",
    },
    config = function()
        local cmp = require('cmp')
        local luasnip = require('luasnip')
        local lspkind = require('lspkind')

        -- loads vscode style snippets from installed plugins
        require("luasnip.loaders.from_vscode").lazy_load()
        luasnip.config.setup {}


        local sources = {
            lsp = { name = 'nvim_lsp' },
            luasnip = { name = 'luasnip' },
            codium = { name = "codeium" },
            buffer = { name = 'buffer' },
            path = { name = 'path', max_item_count = 3 },
        }


        cmp.setup({
            -- Highlight first selection
            completion = {
                completeopt = 'menu,menuone,noinsert'
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            mapping = {
                ['<C-Space>'] = cmp.mapping.complete(), -- show completion suggestions
                ['<C-e>'] = cmp.mapping.abort(),        -- close completion window
                ['<CR>'] = cmp.mapping({
                    i = cmp.mapping.confirm({ select = true }),
                    c = nil,
                }),

                ['<Tab>'] = cmp.mapping.select_next_item(),
                ['<S-Tab>'] = cmp.mapping.select_prev_item(),
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<Down>'] = cmp.mapping.select_next_item(),
                ['<Up>'] = cmp.mapping.select_prev_item(),

                ['<C-d>'] = cmp.mapping.scroll_docs(4),
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),

            },
            sources = cmp.config.sources({
                sources.lsp,
                sources.luasnip,
                sources.codium,
            }, {
                sources.buffer,
                sources.path,
            }),
            formatting = {
                format = lspkind.cmp_format({
                    mode = 'symbol_text',
                    menu = ({
                        buffer = "[Buffer]",
                        nvim_lsp = "[LSP]",
                        luasnip = "[LuaSnip]",
                        path = "[Path]",
                    })
                })
            },
            experimental = {
                ghost_text = { hlgroup = "Comment" }
            },
        })

        -- Use buffer as a source when searching.
        cmp.setup.cmdline({ '/', '?' }, {
            completion = {
                completeopt = 'menu,menuone,noinsert,noselect'
            },
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                sources.buffer,
            }
        })

        -- Use cmdline and path as a source for commands.
        cmp.setup.cmdline(':', {
            completion = {
                completeopt = 'menu,menuone,noinsert,noselect'
            },
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                -- sources.buffer,
            }, {
                { name = 'cmdline' }
            })
        })
    end,
}
