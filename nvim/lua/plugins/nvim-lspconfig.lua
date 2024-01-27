return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lspconfig = require('lspconfig')
        -- Note: Avoid setting up LSPs here. If the same LSP is setup both in here and in mason by mason-lspconfig,
        -- weird errors will occur when we open files via neo-tree (Error: ReadPre autocommands must not change current buffer)

        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#bashls
        -- lspconfig.bashls.setup({})
        -- lspconfig.dartls.setup{}
        -- require'lspconfig'.java_language_server.setup{
        --     cmd = { "/nix/store/f06kd901mbbmay46mhwi9qfcy5j2hclg-java-language-server-0.2.46/share/java/java-language-server/lang_server_linux.sh" }
        -- }
        -- require'lspconfig'.jdtls.setup{
        --     cmd = { "jdt-language-server", "-data", "/home/heyzec/.cache/jdtls/workspace" }
        -- }
    end
}


