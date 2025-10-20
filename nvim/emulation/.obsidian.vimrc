" Mapping Obsidian commands is verbose unfortunately
" See https://github.com/esm7/obsidian-vimrc-support?tab=readme-ov-file#mapping-obsidian-commands-within-vim
" Determine obcommand by opening Dev Console (Ctrl+Shift+I), then running :obcommand

" Basics
imap jk <Esc>
nmap j gj
nmap k gk
unmap <Space>
map <Space>y "+y
vmap <Space>y "+y
map <Space>d "+d
vmap <Space>d "+d
map <Space>p "+p

" Pane navigation
exmap focusLeft obcommand editor:focus-left
nmap <C-h> :focusLeft<CR>
exmap focusRight obcommand editor:focus-right
nmap <C-l> :focusRight<CR>
exmap focusTop obcommand editor:focus-top
nmap <C-k> :focusTop<CR>
exmap focusBottom obcommand editor:focus-bottom
nmap <C-j> :focusBottom<CR>
" Restore default insert link in insert mode
exmap insertLink obcommand editor:insert-link
imap <C-k> <Esc>:insertLink<CR>i

" Tab navigation
exmap nextTab obcommand workspace:next-tab
nmap gt :nextTab<CR>
exmap prevTab obcommand workspace:previous-tab
nmap gT :prevTab<CR>

" Pane management
exmap sp obcommand workspace:split-horizontal
exmap vsp obcommand workspace:split-vertical
exmap q obcommand workspace:close
nmap ZZ :q<CR>

" Others
exmap showContext obcommand editor:context-menu
map z= :showContext<CR>
