" Fix encoding issues
scriptencoding utf-8
set encoding=utf-8
" ---------------1. PLUGINS ENABLE AND CONFIG---------------
call plug#begin()
" Language
Plug 'vim-syntastic/syntastic'
" Completion
" Plug 'Valloric/YouCompleteMe'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Code Display
Plug 'Yggdroot/indentLine'
Plug 'tomasiser/vim-code-dark'
" Interface
Plug 'mbbill/undotree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'tpope/vim-fugitive'

call plug#end()

colorscheme codedark
let g:syntastic_quiet_messages = {'regex': 'missing-module-docstring'}
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_python_python_exec = 'python3'
autocmd CompleteDone * pclose

let g:airline_theme='minimalist'
source $HOME/.vim/plug-config/coc.vim
let g:airline#extensions#tabline#enabled = 1

" ---------------2. BASIC VIM CONFIGURATIONS---------------
imap jk <Esc><Right>
set backspace=indent,eol,start

" Vim user interface
set number
set relativenumber

set showcmd
set wildmenu

" Visualize hidden chars: tabs, non-breaking spaces and trailing spaces
set list
set listchars=tab:▸\ ,nbsp:°,trail:·,eol:↲
hi SpecialKey ctermfg=244 guifg=#808080

" Better searching
set ignorecase
set smartcase
set incsearch
set hlsearch
nnoremap <C-l> :nohlsearch<CR><C-l>
"
"Map Y to act like D and C instead of default yy
noremap Y y$

set showmatch
set matchtime=0

"gj and gk
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'


" ---------------3. BASIC PERSONALISATIONS---------------

" Leader keys

map <leader>u :UndotreeToggle<CR>

" Quickly write as sudo
map <leader>W :w !sudo tee %:p >/dev/null<CR>


" Quickly [E]dit/[S]ource my vim[rc] file
nmap <leader>ve :vsplit $MYVIMRC<CR>
" For some reason, source will cause highlighting of prev search, need Ctrl-L
nmap <leader>vs :source $MYVIMRC<CR><C-l>

" Quickly subst
nmap <leader>s :%s//g<Left><Left>
vmap <leader>s "zy:%s/<C-r>z//g<Left><Left>

" Modify put actions
" noremap p P<Right>
" noremap P p<Right>

" For cut, copy, paste
set mouse=a
map <C-x> "+d
map <C-c> "+y
map <C-v> "+p
imap <C-x> <C-o><C-x>
imap <C-c> <C-o><C-c>
" imap <C-v> <Left><C-o><C-v>
imap <C-v> <C-o><C-v>
" Restores visual block mode. To enter, press S-v in any visual mode.
vnoremap <S-v> <C-v>
" Restores decrementing of number (S changes entire line, use cc)
nnoremap S <C-x>

" ---------------4. ADVANCED PERSONALISATIONS---------------

" Common function required for other customisation
command WriteIfModified if getbufinfo(bufnr('%'))[0].changed | w | endif
function WriteIfModified()
	if getbufinfo(bufnr('%'))[0].changed
		return execute('w')->split('\n')[0]
	endif
	return ''
endfunction

" Quickly comment lines using Ctrl + /
map <C-_> :call Comment()<CR>
function Comment()
	if matchstr(getline(line('.')), '\S') == '' | return | endif

	let ft = &filetype
	function! s:inlist(list, item)
		return index(a:list, a:item) >= 0
	endfunction

	if s:inlist(['php', 'ruby', 'sh', 'make', 'python', 'perl', 'awk', 'conf', 'zsh'], ft)
		let b:comment_char = "#"
	elseif s:inlist(['javascript', 'c', 'cpp', 'java', 'objc', 'scala', 'go'], ft)
		let b:comment_char = "//"
	elseif ft == 'tex'
		let b:comment_char = "%"
	elseif ft == 'vim'
		let b:comment_char = '"'
	else
		echo 'Unknown lang.'
		return
	endif
	if matchstr(getline(line('.')), '^\s*' . b:comment_char) == ''
		execute 'substitute/\S\@=/' . b:comment_char . ' /'
	else
		execute 'substitute/' . b:comment_char . '\s*//'
	endif
endfunction

" Use F3 to F9 for custom functions defined in buffer
for i in range(2, 9)
	execute 'map <F' . i . '> :call CustomExec(' . i . ')<CR>'
	execute 'imap <F' . i . '> <Esc><F' . i . '>'
endfor
function CustomExec(n)
	for i in range(1, 9)
		let cmd = getline(i)
		if cmd[0:1] == '#!' | continue | endif
		let output = matchstrpos(cmd, '\W\s\?[Vv]imF' . a:n)
		if output[0] != ''
			WriteIfModified
			execute cmd[output[2]+1:]
			return
		endif
	endfor
	echo "No commands for F" . a:n . " found."
endfunction

" Autorun commands in file when file opened
autocmd BufReadPost * call VimAu()
function VimAu()
	for i in range(1, 2)
		let cmd = getline(i)
		if cmd[0:1] == '#!' | continue | endif
		let output = matchstrpos(cmd, '\W\s\?[Vv]imAu')
		if output[0] != ''
			execute cmd[output[2]+1:]
			return
		endif
	endfor
endfunction


" Enable terminal stuffs
set noequalalways
map <silent> <leader><F1> :call NewTerm()<CR>
tmap <leader><F1> <C-w><leader><F1>
map <F1> :call Exec()<CR>
imap <F1> <Esc><F1>
tmap <F1> <C-w><F1>

function NewTerm()
	let terms = uniq(map(filter(getwininfo(), 'v:val.terminal'), 'v:val.winid'))
	if len(terms) == 0
		execute 'botright term'
		let bufs = uniq(map(filter(getwininfo(), 'v:val.terminal'), 'v:val.bufnr'))
		let bufnr = bufs[0]
		call setbufvar(bufnr, "&number", 0)
		call setbufvar(bufnr, "&relativenumber", 0)
	else
		echo win_execute(terms[0], 'rightbelow vnew | term ++curwin')
	endif
endfunction
function! Exec(...) " ExecV2
	let msg = []
	if a:0 == 0
		if expand('%') == '' | echo "No filename" | return | endif
		let filepath = expand('%:p')
		let is_not_exec = system('test -x ' . filepath . '; echo $?')
		if is_not_exec && getline(1)[:1] != '#!'
			let userinput = input('Interpreter: ')
			echo "\n"
			if userinput != ''
				call append(0, '#!/usr/bin/env '. userinput)
			endif
		endif
		call add(msg, WriteIfModified())
		if is_not_exec
			call system('chmod +x ' . filepath)
			echo 'File automatically made executable.'
		endif
		let cmd = '"' . filepath . '"'
	else
		let cmd = a:1
	endif

	if len(filter(getwininfo(), 'v:val.terminal')) == 0 | call NewTerm() | endif
	let terms = uniq(map(filter(getwininfo(), 'v:val.terminal'), 'v:val.bufnr'))
	let bufnr = terms[0]
	if system('ps -eo ppid= | grep ' . term_getjob(bufnr)->split(' ')[1]) != ''
		call term_sendkeys(bufnr, "\<C-c>\<CR>")
		call add(msg, 'SIGINT sent to terminal')
	endif
	call term_sendkeys(bufnr, cmd . "\<CR>")
	echo join(msg, ', ')
endfunction


" Scrollable terminal - Adapted from https://github.com/vim/vim/issues/2490
let s:term_pos = {} " { bufnr: [winheight, n visible lines] }

tnoremap <silent> <ScrollWheelUp> <C-w>:call TermScrollUp()<CR>
tnoremap <silent> <ScrollWheelDown> <C-w>:call TermScrollDown()<CR>
nnoremap <silent> <ScrollWheelDown> <ScrollWheelDown>:call TermExitNormIfBottom()<CR>
nnoremap <silent> <Up> <Up>:call TermExitNormIfArrow('Up')<CR>
nnoremap <silent> <Down> <Down>:call TermExitNormIfArrow('Down')<CR>
nnoremap <silent> <Left> <Left>:call TermExitNormIfArrow('Left')<CR>
nnoremap <silent> <Right> <Right>:call TermExitNormIfArrow('Right')<CR>

function TermSendSpecialKey(bufnr, key)
	execute 'call term_sendkeys(' . a:bufnr . ', "\<' . a:key . '>")'
endfunction
function TermScrollUp()
	if term_getaltscreen(bufnr()) == 1
		for i in range(3)
			call TermSendSpecialKey(bufnr(), 'Up')
		endfor
	else
		call EnterTermNorm()
	endif
endfunction
function TermScrollDown()
	for i in range(3)
		call TermSendSpecialKey(bufnr(), 'Down')
	endfor
endfunction
function EnterTermNorm()
	if &buftype != 'terminal' || mode('') != 't' | return | endif
	call feedkeys("\<LeftMouse>\<c-w>N", 'x')
	let s:term_pos[bufnr()] = [winheight(winnr()), line('$') - line('w0')]
	call feedkeys("\<ScrollWheelUp>")
endfunction
function TermExitNormIfBottom()
	if &buftype != 'terminal' || !(mode('') == 'n' || mode('') == 'v') | return | endif
	let old_winheight = s:term_pos[bufnr()][0]
	let old_n_visible = s:term_pos[bufnr()][1]
	let n_visible = line('$') - line('w0')
	let n_empty = winheight(winnr()) - n_visible
	" if size has only expanded, match visible lines on entry
	if old_n_visible <= winheight(winnr())
		if n_visible <= old_n_visible | call feedkeys('i', 'x') | endif
	" if size has shrunk, match visible empty lines on entry
	else
		let old_n_empty = old_winheight - old_n_visible
		if n_empty >= old_n_empty || n_empty >= winheight(winnr())
			call feedkeys('i', 'x')
		endif
	endif
endfunction
function TermExitNormIfArrow(key)
	if &buftype != 'terminal' || !(mode('') == 'n' || mode('') == 'v') | return | endif
	call feedkeys('i', 'x')
	call TermSendSpecialKey(bufnr(), a:key)
endfunction

set viminfo+=n~/.vim/viminfo  " Put the .viminfo file in the .vim folder too
