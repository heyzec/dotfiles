return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local lspconfig = require('lspconfig')
        -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#bashls
        lspconfig.bashls.setup({})
        lspconfig.dartls.setup{}
        -- require'lspconfig'.java_language_server.setup{
        --     cmd = { "/nix/store/f06kd901mbbmay46mhwi9qfcy5j2hclg-java-language-server-0.2.46/share/java/java-language-server/lang_server_linux.sh" }
        -- }
        require'lspconfig'.jdtls.setup{
            cmd = { "jdt-language-server", "-data", "/home/heyzec/.cache/jdtls/workspace" }
        }
    end
}


