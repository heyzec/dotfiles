" ------------------------------ ------------------------------

" 1. PLUGIN LIST & CONFIGURATIONS {{{
" ###############################################################################
" ##                                                                           ##
" ##                      1. PLUGIN LIST & CONFIGURATIONS                      ##
" ##                                                                           ##
" ###############################################################################

" -------------------Map the leader key first-----------------
let mapleader = "\<space>"                      " the easiest button to hit

" 1.1. vim-plug auto-installer {{{
" -------------Auto install vim-plug (from github)------------
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}

" 1.2. Plugin List {{{
call plug#begin()
" -------------------------A. Language------------------------
" ------------------------B. Completion-----------------------
Plug 'jiangmiao/auto-pairs'

" -----------------------C. Code Display----------------------
Plug 'Yggdroot/indentLine'                      " display indention with thin vertical lines
Plug 'tomasiser/vim-code-dark'                  " dark color scheme like vscode

" ------------------------D. Interface------------------------
Plug 'mbbill/undotree'                          " visualise undo history with branches
Plug 'vim-airline/vim-airline'                  " statusline
Plug 'vim-airline/vim-airline-themes'           " theme statusline to match dark color scheme
Plug 'tpope/vim-fugitive'                       " git integration

" -------------------------E. Commands------------------------
Plug 'tpope/vim-commentary'                     " lightweight commenting plugin

" Plug 'ThePrimeagen/vim-be-good'
" }}} 1.2. Plugin List

" 1.3. Plugin Configurations {{{
" -------------------------A. Language------------------------
" Enable and configure language-related plugins in separate lua script
if has('nvim') && !exists('g:vscode')
    runtime lsp_init.lua
else
    call plug#end()
endif
set completeopt=menu,menuone,noselect


" ------------------------B. Completion-----------------------
" -----------------------C. Code Display----------------------
" configure tomasiser/vim-code-dark
colorscheme codedark

" ------------------------D. Interface------------------------
" configure mbbill/undotree
noremap <leader>u :UndotreeToggle<CR>

" configure vim-airline/vim-airline
let g:airline_theme='minimalist'
let g:airline#extensions#tabline#enabled=1

" configure iamcco/markdown-preview.nvim
let g:mkdp_auto_start=1

" -------------------------E. Commands------------------------
" }}} 1.3. Plugin Configurations

" }}} 1. PLUGIN LIST & CONFIGURATIONS

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
nnoremap <leader>cd :cd %:p:h<CR>

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

noremap <leader>e :Lexplore<CR>
" TO DO: only do subst within selected visual-line lines
" vmap <expr> <leader>q mode() == 'v' ? "j" : "k"
" }}}

" }}} 3. KEYMAPPINGS

" 4. THINGS THAT SHOULD BE PLUGINS {{{
" ###############################################################################
" ##                                                                           ##
" ##                      4. THINGS THAT SHOULD BE PLUGINS                     ##
" ##                                                                           ##
" ###############################################################################

" A useful function
command WriteIfModified if getbufinfo(bufnr('%'))[0].changed | w | endif
function WriteIfModified()
    if getbufinfo(bufnr('%'))[0].changed
        " return execute('w')->split('\n')[0]
        return split(execute('w'), '\n')[0]
    endif
    return ''
endfunction


" Use <leader>1 to <leader>9 to run custom functions defined in buffer
for i in range(1, 9)
    execute 'noremap <leader>' . i . ' :call VimCmd(' . i . ')<CR>'
    execute 'noremap <F' . i . '> :call VimCmd(' . i . ')<CR>'
    execute 'inoremap <F' . i . '> <Esc><F' . i . '>'
endfor
function! VimCmd(n)
    for i in range(1, 9)
        let line = getline(i)
        if line[0:1] == '#!' | continue | endif
        let output = matchstrpos(line, '\W\s\?[Vv]imCmd' . a:n)
        if output[0] != ''
            WriteIfModified
            execute line[output[2]+1:]
            return
        elseif line != ''
            break
        endif
    endfor
    echo "No commands for VimCmd" . a:n . " found."
endfunction


" Autorun hook commands in buffer when file is opened
autocmd BufReadPost * call VimHook()
function! VimHook()
    for i in range(1, 2)
        let line = getline(i)
        if line[0:1] == '#!' | continue | endif
        let output = matchstrpos(line, '\W\s\?[Vv]imHook')
        if output[0] != ''
            execute line[output[2]+1:]
            return
        endif
    endfor
endfunction

" }}} 4. THINGS THAT SHOULD BE PLUGINS


