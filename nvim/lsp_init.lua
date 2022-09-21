local Plug = vim.fn['plug#']
-- vim.call('plug#begin')
Plug 'neovim/nvim-lspconfig'                -- required for nvim LSP
Plug 'williamboman/nvim-lsp-installer'      -- manage LSP servers
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'                     -- Autocompletion
Plug 'hrsh7th/lspkind-nvim'

Plug 'nvim-lua/plenary.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'williamboman/mason.nvim'              -- Manage external editor tooling i.e LSP servers

Plug('nvim-treesitter/nvim-treesitter',     -- Highlight, edit, and navigate code
    {['do'] = ':TSUpdate'})                 -- Automate updating of parsers on update
vim.call('plug#end')


require("nvim-lsp-installer").on_server_ready(function(server)
    local opts = {}
    server:setup(opts)
end)

-- nvim-cmp {{{
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
}


-- Setup nvim-cmp.
local cmp = require'cmp'
local lspkind = require('lspkind')

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
    mapping = {
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping({
            i = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ select = false }),
        }),
        -- My mappings
        ['<Tab>'] = cmp.mapping({
            i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
            c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        }),
        ['<S-Tab>'] = cmp.mapping({
            i = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
            c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
        }),
        ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item()),
        ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item()),

        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c' }),

    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }, {
      { name = 'buffer' },
    }),
    formatting = {
        fields = { "kind", "abbr" },
        format = function(_, vim_item)
            vim_item.kind = cmp_kinds[vim_item.kind] or ""
            return vim_item

        end,
    }
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
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
})-- }}}

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}

-- Setup mason so it can manage external tooling
require("mason").setup()

require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.stylua,
        require("null-ls").builtins.diagnostics.eslint,
        -- require("null-ls").builtins.completion.spell,
    },
})
