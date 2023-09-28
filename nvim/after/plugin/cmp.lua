-- ##### CODE COMPLETION #####
-- Setup nvim-cmp.
local cmp = require('cmp')

-- https://github.com/microsoft/vscode-codicons/blob/main/dist/codicon.ttf
local cmp_kinds = {
    Text          = '  ',
    Method        = '  ',
    Function      = '  ',
    Constructor   = '  ',
    Field         = '  ',
    Variable      = '  ',
    Class         = '  ',
    Interface     = '  ',
    Module        = '  ',
    Property      = '  ',
    Unit          = '  ',
    Value         = '  ',
    Enum          = '  ',
    Keyword       = '  ',
    Snippet       = '  ',
    Color         = '  ',
    File          = '  ',
    Reference     = '  ',
    Folder        = '  ',
    EnumMember    = '  ',
    Constant      = '  ',
    Struct        = '  ',
    Event         = '  ',
    Operator      = '  ',
    TypeParameter = '  ',
    Codeium       = '" ',
}


cmp.setup({
    -- Highlight first selection
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = {
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping({
            i = cmp.mapping.confirm({ select = true }),
            c = nil,
        }),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),

        ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item()),
        ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item()),

        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),

    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = "codeium" },
    }, {
        { name = 'buffer' },
    }),
    formatting = {
        fields = { "kind", "abbr" },
        format = function(_, vim_item)
            vim_item.kind = cmp_kinds[vim_item.kind] or ""
            return vim_item

        end,
    },
    experimental = {
        ghost_text = {hlgroup = "Comment"}
    },
})

-- Use buffer as a source when searching.
cmp.setup.cmdline('/', {
    completion = {
        completeopt = 'menu,menuone,noinsert,noselect'
    },
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use buffer as a source when reverse searching.
cmp.setup.cmdline('?', {
    completion = {
        completeopt = 'menu,menuone,noinsert,noselect'
    },
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline and path as a source for commands.
cmp.setup.cmdline(':', {
    completion = {
        completeopt = 'menu,menuone,noinsert,noselect'
    },
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

