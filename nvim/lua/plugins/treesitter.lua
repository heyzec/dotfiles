return {
    -- Lock to specific commmit because triggering indent will lag on dart files:
    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/4945#issuecomment-1691168369
    {
        "nvim-treesitter/nvim-treesitter",
        commit = "f2778bd1a28b74adf5b1aa51aa57da85adfa3d16",
        build = ":TSUpdate",

        event = vim.g.vscode and nil or { "LazyFile", "VeryLazy" },
        lazy = not vim.g.vscode,
        cond = true, -- always load this plugin, even if vscode

        init = function(plugin)
            -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
            -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
            -- no longer trigger the **nvim-treeitter** module to be loaded in time.
            -- Luckily, the only thins that those plugins need are the custom queries, which we make available
            -- during startup.
            require("lazy.core.loader").add_to_rtp(plugin)
            require("nvim-treesitter.query_predicates")
        end,
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-textobjects",
                commit = "35a60f093fa15a303874975f963428a5cd24e4a0",
                cond = true,
                config = function()
                end,
            },
            {
                'nvim-treesitter/nvim-treesitter-refactor',
                cond = true,
            },
        },
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        keys = {
            { "<c-space>", desc = "Increment selection" },
            { "<bs>", desc = "Decrement selection", mode = "x" },
        },
        ---@diagnostic disable-next-line: missing-fields
        opts = {
            highlight = { enable = true },
            indent = { enable = true },
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
                        smart_rename = false,  -- disable default grr keymap
                    },
                },
            },
            auto_install = true,
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
                        ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },

                        ["af"] = { query = "@function.outer", desc = "Select outer part of a function definition" },
                        ["if"] = { query = "@function.inner", desc = "Select inner part of a function definition" },

                        ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
                        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },

                        ["am"] = { query = "@comment.outer", desc = "Select outer part of a comment" },
                        ["im"] = { query = "@comment.inner", desc = "Select inner part of a comment" },

                        ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter" },
                        ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter" },
                    },
                },
                selection_modes = {
                    ['@loop.outer'] = 'V',
                    ['@function.outer'] = 'V',
                    ['@class.outer'] = 'V',
                    ['@comment.outer'] = 'V',
                },
                move = {
                    enable = true,
                    goto_next_start = {
                        ["]a"] = "@parameter.outer",
                    },
                }
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },

    -- Show context of the current function
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "LazyFile",
        enabled = true,
        opts = { mode = "cursor", max_lines = 3 },
        cond = true,
    },
}

