## Keymaps
As much as possible, I try to choose keymaps that follow conventions.
This table shows the common keymaps in the wild. The keymaps I chose is bolded.

|Keybind    |Vim                        |nvim-lspconfig/LazyVim         |vscode-neovim|
|---|---|---|---|
|gd         |Goto local declaration     |**vim.lsp.buf.definition**<sup>1</sup>    |**editor.action.revealDefinition**|
|^^         |^^                         |telescope.lsp_definitions<sup>2</sup>     |^^|
|gD         |Goto global declaration    |vim.lsp.buf.declaration        |editor.action.peekDefinition|
|K          |`keywordprg` (default man) |**vim.lsp.buf.hover**          |**editor.action.showHover**|
|gK         |-                          |vim.lsp.buf.signature_help<sup>2</sup>
|[i]\<C-k>  |Digraphs                   |vim.lsp.buf.signature_help
|gf         |Goto file under cursor     |                               |editor.action.revealDeclaration|
|gF         |gf for `filename:lineno`   |                               |editor.action.peekDeclaration|
|gh         |Charwise select mode       |                               |editor.action.showHover|
|gH         |Linewise select mode       |                               |editor.action.referenceSearch.trigger|
|gO         |Buffer outline (help, :Man)|                               |**workbench.action.gotoSymbol**|
|gr         |Replace virtual char       |vim.lsp.buf.references<sup>1</sup>
|^^         |^^                         |telescope.lsp_references<sup>2</sup>
|gy         |-                          |**telescope.lsp_type_definition**<sup>2</sup>
|gI         |Like I but for ^ instead 0 |telescope.lsp_implementations<sup>2</sup>
|\<space>D|                             |vim.lsp.buf.type_definition<sup>1</sup>
|\<space>rn|                            |vim.lsp.buf.rename<sup>1</sup>
|\<space>f|                             |vim.lsp.buf.format<sup>1</sup>
|\<leader>cl|NA                         |:LspInfo<sup>2</sup>
|[n,v]\<leader>ca|NA                    |vim.lsp.buf.code_action
|\<leader>cA|NA                         |vim.lsp.buf.code_action variant<sup>2</sup>

<sup>1</sup> Only defined by nvim-lspconfig
<sup>2</sup> Only defined by LazyVim

## Note
- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/keymaps.lua
- https://github.com/neovim/nvim-lspconfig#suggested-configuration

Note: The LSP protocol does not have an interface for refactoring
