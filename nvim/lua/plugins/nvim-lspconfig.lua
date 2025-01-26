-- NOTE: Avoid setting up LSPs here.
-- If the same LSP is setup both in here and in mason by mason-lspconfig,
-- weird errors will occur when we open files via neo-tree (Error: ReadPre autocommands must not change current buffer)
return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
    end
}
