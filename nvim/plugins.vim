
" ###############################################################################
" ##                                                                           ##
" ##                      1. PLUGIN LIST & CONFIGURATIONS                      ##
" ##                                                                           ##
" ###############################################################################


" 1.1. vim-plug auto-installer
" -------------Auto install vim-plug (from github)------------
" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" 1.2. Plugin List
call plug#begin()
" -------------------------A. Language------------------------
" ------------------------B. Completion-----------------------
Plug 'jiangmiao/auto-pairs'

" -----------------------C. Code Display----------------------
Plug 'Yggdroot/indentLine'                      " display indention with thin vertical lines
Plug 'tomasiser/vim-code-dark'                  " dark color scheme like vscode

" ------------------------D. Interface------------------------
Plug 'mbbill/undotree'                          " visualise undo history with branches
" Plug 'vim-airline/vim-airline'                  " statusline
" Plug 'vim-airline/vim-airline-themes'           " theme statusline to match dark color scheme
Plug 'tpope/vim-fugitive'                       " git integration

" -------------------------E. Commands------------------------
Plug 'tpope/vim-commentary'                     " lightweight commenting plugin
call plug#end()


" 1.3. Plugin Configurations

" -------------------------A. Language------------------------
" Enable and configure language-related plugins in separate lua script
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

" -------------------------E. Commands------------------------

