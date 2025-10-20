imap jk <Esc>
nmap j gj
nmap k gk

" exmap followlink obcommand editor:follow-link
" map <Space><CR> :followlink<CR>

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
" Restore default insert link
exmap insertLink obcommand editor:insert-link
imap <C-k> <Esc>:insertLink<CR>i


exmap sp obcommand workspace:split-horizontal
exmap vsp obcommand workspace:split-vertical
exmap q obcommand workspace:close
nmap ZZ :q<CR>


exmap showContext obcommand editor:context-menu
map z= :showContext<CR>

" Determine obcommand by opening Dev Console (Ctrl+Shift+I), then running :obcommand

