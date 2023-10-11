require('nvim-treesitter.configs').setup {
    build = ":TSUpdate", -- Update parsers when treesitter is updated
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
    indent = {
        enable = true,
        disable = {"python"}
    },
    -- Check for these parsers and install if missing
    ensure_installed = {
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "markdown",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "python",
        "go",
        "gosum",
        "gomod",
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<C-Space>",
            node_incremental = "<C-Space>",
            scope_incremental = false,
            node_decremental = "<bs>",
        },
    },
    textobjects = {
        select = {
            enable = true,
            keymaps = {
                ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
                ["il"] = { query = "@loop.inner", desc = "Select outer part of a loop" },

                ["af"] = { query = "@function.outer", desc = "Select outer part of a function definition" },
                ["if"] = { query = "@function.inner", desc = "Select outer part of a function definition" },

                ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
                ["ic"] = { query = "@class.inner", desc = "Select outer part of a class" },
            },
        },
    },
}

require("treesitter-context").setup{
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
