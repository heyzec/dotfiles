" ------------------------------ ------------------------------
" -------------------Map the leader key first-----------------
let mapleader = "\<space>"                      " the easiest button to hit

if !exists('g:vscode')
    runtime plugins.vim
    if has('nvim')
        runtime plugins.lua
    endif
endif

set termguicolors


" 2. BASIC VIM CONFIGURATIONS {{{
" ###############################################################################
" ##                                                                           ##
" ##                        2. BASIC VIM CONFIGURATIONS                        ##
" ##                                                                           ##
" ###############################################################################

" Absolute essentials!: Escape mapping, enable mouse {{{
if !exists('g:vscode')
    inoremap <silent> jk <Esc><Right>
endif
set mouse=a                                     " enable mouse in all modes
if !has('nvim')
    set ttymouse=xterm2                         " allow mouse through tmux, ssh
endif
" let mapleader = "\<space>"                    " is set above in PLUGINS section
" }}}

" Appearance: Ruler, cursor and visualising chars {{{
set showcmd                                     " display last command  (default in nvim)

" ----------------------------Ruler----------------------------
set number                                      " enable numbers on the left ...
set relativenumber                              " ... but make current line 0

" ----------------------------Cursor---------------------------
set cursorline                                  " highlight current line
if !exists('g:vscode')
    set scrolloff=4                             " keep cursor centered (4 lines from edges)
endif
let &t_SI = "\e[5 q"                            " change to i-beam cursor when entering insert mode
let &t_EI = "\e[2 q"                            " change to block cursor when leaving insert mode

" -------------------Visualize hidden chars--------------------
set list
set listchars=tab:\|\ ,trail:·,nbsp:⎵           " tabs, non-breaking spaces, trailing spaces
if !has('g:vscode')                                 " make these chars display in gray instead of blue
    augroup visualise_chars                         " only show eol when in insert mode
        autocmd!
        autocmd InsertEnter * set listchars+=eol:↲
        autocmd InsertLeave * set listchars-=eol:↲
    augroup end
endif
if !has('nvim')
    hi SpecialKey ctermfg=244 guifg=#808080
endif
" }}} Appearance: Ruler, cursor and visualising chars

" Editing: Search, splits and indentation {{{
" --------------------------Searching--------------------------
" set path+=**                                    " allow recursive :find
" setglobal complete-=i
set wildmenu                                    " enable command line completion (default in nvim)
set wildmode=longest:full,full                  " don't default to 1st option e.g. `:e` (like bash)
set wildignorecase                              " ignore case when searching

set ignorecase                                  " searches are case insensitive
set smartcase                                   " search case sensitive if contains an uppercase letter
set incsearch                                   " incremental search (default in nvim)
set hlsearch                                    " highlight text while searching (default in nvim)
if has('nvim')
    set inccommand=nosplit                      " visual feedback while substituting
endif
" Allow quick clearing of highlighted search results
" Using <Esc><Esc> as a vim mapping is glitchy, see online for reasons
nnoremap <leader><Esc> :nohlsearch<CR>

set wildmenu                                    " enable command line completion (default in nvim)
set wildmode=longest:full,full                  " don't default to 1st option e.g. `:e` (like bash)

" ---------------------------Buffers---------------------------
set splitbelow                                  " natural splits - :sp places new win below
set splitright                                  " natural splits - :vsp places new win right

" -----------------------Tabs and spaces-----------------------
" set backspace=indent,eol,start                " allow backspacing over everything in insert mode
set tabstop=4
set shiftwidth=4                                " use 4 spaces width for indents
set expandtab                                   " insert 4 spaces when tab pressed

" ---------------------------Others---------------------------
if has('nvim')                                  " vim and nvim uses different undofiles
    set undofile                                " enable persistent undo
    set undodir=/tmp                            " undo temp file directory
endif
set foldmethod=marker
" }}} Editing: Search, splits and indentation
" testing

" let g:netrw_winsize = 15

" }}} 2. BASIC VIM CONFIGURATIONS

" 3. KEYMAPPINGS {{{
" ###############################################################################
" ##                                                                           ##
" ##                              3. KEYMAPPINGS                               ##
" ##                                                                           ##
" ###############################################################################

" Basic keymappings {{{
" context-based j and k - gj usually, but j if count is given
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'

" make Y more consistent - yank till end (like D and C)
noremap Y y$

" no more `how did we get here?`
noremap Q :echo 'No more Ex mode!'<CR>

" :w looks simple at first but it's not
noremap <leader>w :w<CR>

" cd vim into the directory of the current buffer
nnoremap <leader>d :cd %:p:h<CR>

" Tabs to switch buffers
if !exists('g:vscode')
    nnoremap <Tab>   :bnext<CR>
    nnoremap <S-Tab> :bprevious<CR>
else
    nnoremap <Tab>   :tabnext<CR>
    nnoremap <S-Tab> :tabprevious<CR>
endif
" }}} Basic keymappings

" [e]dit/[s]ource my [v]imrc {{{
nnoremap <leader>ve :vsplit $MYVIMRC<CR>
nnoremap <leader>vl :execute printf('vsplit %s/'.LSP_INIT_FILE, fnamemodify($MYVIMRC, ':h'))<CR>
if !exists('g:vscode')
    nnoremap <leader>vs :silent! call win_execute(win_findbuf(bufnr($MYVIMRC))[0], 'w') <bar> source $MYVIMRC<CR>
else
    nnoremap <leader>vs :source $MYVIMRC<CR>
endif
" }}}

" [s]ubstitutions {{{
if !exists('g:vscode')
    nnoremap <leader>s :%s//g<Left><Left>
else
    nnoremap <leader>s :call VSCodeNotify('editor.action.startFindReplaceAction')<CR>
endif
vnoremap <leader>s "zy:%s/<C-r>z//g<Left><Left>
" }}}

" Splits controls {{{
" Switching between splits (alt + h,j,k,l)
noremap <A-h>     <C-w>h
noremap <A-j>     <C-w>j
noremap <A-k>     <C-w>k
noremap <A-l>     <C-w>l
tnoremap <A-h> <C-\><C-n><c-w>h
tnoremap <A-j> <C-\><C-n><c-w>j
tnoremap <A-k> <C-\><C-n><c-w>k
tnoremap <A-l> <C-\><C-n><c-w>l

" Resizing splits (ctrl + arrows keys)
noremap <C-Left>  <C-w><
noremap <C-Right> <C-w>>
noremap <C-Up>    <C-w>+
noremap <C-Down>  <C-w>-
" }}}

" Moving v-block selection (alt + j,k) {{{
" Let the Alt key be mappable (only need fix for vim)
if !has('nvim')
    execute "set <A-j>=\ej"
    execute "set <A-k>=\ek"
endif

vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
" }}}

" Others {{{
" Quickly write as sudo (Doesn't work on nvim! waiting for a fix...)
if !has('nvim')
    noremap <leader>W :w !sudo tee %:p >/dev/null<CR>
endif

noremap <leader>e :NvimTreeToggle<CR>
" TO DO: only do subst within selected visual-line lines
" vmap <expr> <leader>q mode() == 'v' ? "j" : "k"
" }}}

" }}} 3. KEYMAPPINGS


