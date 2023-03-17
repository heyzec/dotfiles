local Plug = vim.fn['plug#']
-- vim.call('plug#begin')

Plug 'neovim/nvim-lspconfig'                -- required for nvim LSP

Plug 'williamboman/mason.nvim'              -- Manage external editor tooling i.e LSP servers
Plug 'williamboman/mason-lspconfig.nvim'

Plug 'hrsh7th/nvim-cmp'                     -- Autocompletion
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

Plug('nvim-treesitter/nvim-treesitter',     -- Highlight, edit, and navigate code
    {['do'] = ':TSUpdate'})                 -- Automate updating of parsers on update
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'nvim-treesitter/nvim-treesitter-context'

Plug 'nvim-lua/plenary.nvim'
Plug 'jcdickinson/codeium.nvim'

vim.call('plug#end')


-- Setup mason so it can manage external tooling
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers {
    function (server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {}
    end,
}


require("codeium").setup({})
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
    Codeium       = '" ',
}


-- Setup nvim-cmp.
local cmp = require'cmp'
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
-- }}} nvim-cmp

-- treesitter {{{
require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    refactor = {
        highlight_definitions = {
            enable = true,
            -- Set to false if you have an `updatetime` of ~100.
            clear_on_cursor_move = true,
        },
        highlight_current_scope = { enable = true },
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "grr",
            },
        },
    },
}

require'treesitter-context'.setup{
    enable = true,
    max_lines = 0,
    trim_scope = 'outer',
    min_window_height = 0,
    patterns = {
        default = {
            'class',
            'function',
            'method',
            'for',
            'while',
            'if',
            'switch',
            'case',
            'interface',
            'struct',
            'enum',
        },
        tex = {
            'chapter',
            'section',
            'subsection',
            'subsubsection',
        },
        haskell = {
            'adt'
        },
        rust = {
            'impl_item',

        },
        terraform = {
            'block',
            'object_elem',
            'attribute',
        },
        scala = {
            'object_definition',
        },
        vhdl = {
            'process_statement',
            'architecture_body',
            'entity_declaration',
        },
        markdown = {
            'section',
        },
        elixir = {
            'anonymous_function',
            'arguments',
            'block',
            'do_block',
            'list',
            'map',
            'tuple',
            'quoted_content',
        },
        json = {
            'pair',
        },
        typescript = {
            'export_statement',
        },
        yaml = {
            'block_mapping_pair',
        },
    },
}
-- }}} treesitter


