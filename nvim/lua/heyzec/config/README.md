## Keymaps
As much as possible, I try to choose keymaps that follow conventions.
This table shows the common keymaps in the wild. The keymaps I chose is bolded.

|Keybind    |Vim                        |Neovim/LazyVim         |vscode-neovim|
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
|gO         |Buffer outline (help, :Man)|vim.lsp.buf.document_symbol()  |workbench.action.gotoSymbol|
|gr         |Replace virtual char       |<s>vim.lsp.buf.references<sup>1</sup></s>
|^^         |^^                         |<s>telescope.lsp_references<sup>2</sup></s>
|grn        |                           |vim.lsp.buf.rename()
|[n,v]gra   |                           |vim.lsp.buf.code_action()
|grr        |                           |vim.lsp.buf.references()
|gri        |                           |vim.lsp.buf.implementation()
|gy         |-                          |**telescope.lsp_type_definition**<sup>2</sup>
|gI         |Like I but for ^ instead 0 |telescope.lsp_implementations<sup>2</sup>
|\<leader>cl|NA                         |:LspInfo<sup>2</sup>
|\<space>f|                             |vim.lsp.buf.format<sup>1</sup>
|\<space>D|                             |vim.lsp.buf.type_definition<sup>1</sup>
|\<space>rn|                            |vim.lsp.buf.rename<sup>1</sup>
|[n,v]\<leader>ca|NA                    |vim.lsp.buf.code_action
|\<leader>cA|NA                         |vim.lsp.buf.code_action variant<sup>2</sup>

<sup>1</sup> <s>Recommended by nvim-lspconfig: [here](https://github.com/neovim/nvim-lspconfig/blob/01b25ff1a66745d29ff75952e9f605e45611746e/README.md#suggested-configuration)</s> nvim-lspconfig no longer recommends these keymaps on their README.

<sup>2</sup> Default of LazyVim: [here](https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/keymaps.lua)

## Note
The LSP protocol does not have an interface for refactoring
