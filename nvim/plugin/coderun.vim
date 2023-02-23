
" Make nvim autoscroll output in terminal
" 1. TERMINAL AND REPL CONFIGS {{{
" ###############################################################################
" ##                                                                           ##
" ##                        1. TERMINAL AND REPL CONFIGS                       ##
" ##                                                                           ##
" ###############################################################################

" Simple command to create a terminal split
command! Term call NewTerm(<q-mods>)

" Double-tap spacebar to open a terminal or run previous command!
noremap <leader><leader> :call Double()<CR>

" Stop running process even when not focused on the terminal
noremap <leader>c :execute 'call TermExec(TermGetFirst(), "\<' . 'C-c>")'<CR>


" Helper functions {{{

"Double-tap spacebar to run code!
noremap <leader><leader> :call RunCode()<CR>
if has('nvim')
    au TermOpen * let g:tb=bufnr()
    au TermClose * unlet g:tb
    autocmd BufWinEnter,WinEnter term://* startinsert
else
    au TerminalWinOpen * let g:tb=bufnr()
endif

function Double()
    if !exists('g:tb')
        call NewTerm()
        return
    endif
    call RunPrev()
endfunction

function RunPrev()
    " Make terminal execute its previous command
    if exists('g:vscode')
        call VSCodeNotify('workbench.action.terminal.sendSequence', { "text": "\u001b[A\u000A" })
        return
    endif
    if has('nvim')
        let jobid = filter(nvim_list_chans(), 'v:val.mode == "terminal" && v:val.buffer == ' . g:tb)[0]['id']
        call chansend(jobid, "\<Esc>[A\<CR>")
    else
        call term_sendkeys(g:tb, "\<Up>\<CR>")
    end
endfunction


function! NewTerm(...)
    " if exists('g:vscode')
    "     call VSCodeNotify('workbench.action.terminal.toggleTerminal')
    "     return
    " endif
    " Opens a term at the bottom of the screen, and go into insert mode
    let mods = a:0 >= 1 && a:1 != "" ? a:1 : 'botright'  " By default open term across splits below

    if has('nvim')
        execute mods 'split term://$SHELL'
        " https://www.reddit.com/r/neovim/comments/mq4zyh/comment/gulaqp5/?utm_source=share&utm_medium=web2x&context=3
        " normal G
        " normal i
    else
        execute mods 'term'
    endif
endfunction


function! TermGetFirst()
    " Returns the bufnr of the first terminal
    return uniq(map(filter(getwininfo(), 'v:val.terminal'), 'v:val.bufnr'))[0]
endfunction


function! TermExec(bufnr, cmd)
    " Send command to the the terminal buffer
    if has('nvim')
        let jobid = filter(nvim_list_chans(), 'v:val.mode == "terminal" && v:val.buffer == ' . a:bufnr)[0]['id']
        call chansend(jobid, [a:cmd, ''])
    else
        call term_sendkeys(a:bufnr, a:cmd . "\<CR>")
    endif
endfunction


function! TermCheckIfRunning(bufnr)
    " Returns 1 if the terminal shell process still has running child processes
    return system('ps -eo ppid= | grep -w ' . getbufvar(a:bufnr, 'terminal_job_pid')) != ''
endfunction
" }}} Helper functions

" Change scrolling behaviour {{{
if has('nvim')
    " Make terminal in nvim more like vim
    augroup terminal_setup
        autocmd!
        " Bypass normal mode when changing focus to terminal buffer (neovim things)
        autocmd TermOpen * nnoremap <buffer><LeftRelease> <LeftRelease>i
        " autocmd BufWinEnter,WinEnter term://* startinsert
        " Toggle numbers off when in terminal mode, on when in normal mode
        autocmd TermEnter term://* setlocal nonu nornu
        autocmd TermLeave term://* setlocal nu rnu
        " Immediately close terminal window when process finishes
        autocmd TermClose term://* close
    augroup end

    " Easily escape terminal mode
    tnoremap <Esc> <C-\><C-n>

    " Simple scrolling in term
    tnoremap <S-Up>   <C-\><C-N><C-B>
    tnoremap <S-Down> <C-\><C-N><C-F>
else
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
endif
" }}} Change scrolling behaviour

" }}} 1. TERMINAL AND REPL CONFIGS

" 2. CODE RUNNER {{{
" ###############################################################################
" ##                                                                           ##
" ##                               2. CODE RUNNER                              ##
" ##                                                                           ##
" ###############################################################################
noremap <leader>r :call RunCode()<CR>

function! RunCode()
    " Run code in the current buffer. Behaviour depends on if vscode is attached.

    if exists('g:vscode')
        call VSCodeNotify('code-runner.run')
        return
    end

    if expand('%') == '' | echo "Can't run code, no filename" | return | endif

    let cmd = GetCodeRunCmd()
    if cmd == ''
        let filepath = expand('%:p')
        let is_not_executable = system('test -x "' . filepath . '"; echo $?')

        if is_not_executable && getline(1)[:1] != '#!'
            let userinput = input({'prompt': 'Interpreter: ', 'cancelreturn': "\<Esc>"})
            echo "\n"
            if userinput == "\<Esc>"
                echo 'Okay, cancelled'
                return
            elseif userinput != ''
                call append(0, '#!/usr/bin/env '. userinput)
            endif
        endif
    endif

    call WriteIfModified()
    if cmd == ''
        if is_not_executable
            call system('chmod +x "' . filepath . '"')
            echo 'File automatically made executable.'
        endif
        let cmd = '"' . filepath . '"'
    endif

    if len(filter(getwininfo(), 'v:val.terminal')) == 0 | call NewTerm() | endif

    let bufnr = TermGetFirst()
    if TermCheckIfRunning(bufnr)
        call TermExec(bufnr, "\<C-c>")
        echo 'SIGINT sent to terminal'
    endif
    call TermExec(bufnr, cmd)
endfunction



function! GetJsonLocation()
    if isdirectory(expand('$HOME/.config/nvim'))
        return expand('$HOME/.config/nvim/coderun.json')
    endif
    return expand('$HOME/.vim/coderun.json')
endfunction


function! GetCodeRunCmd()

    function! Quote(str)
        return '"' . a:str . '"'
    endfunction

    let filepath = expand('%:p')
    let basename = expand('%:t')
    let dirname = expand('%:p:h')
    let ext = expand('%:e')
    let stem = substitute(basename, '.' . ext, '', 'g')

    let dict = json_decode(join(readfile(GetJsonLocation()), ''))
    if !has_key(dict, &filetype)
        return
    endif

    let cmd = dict[&filetype]
    let cmd = substitute(cmd, '$filepath', Quote(filepath), 'g')
    let cmd = substitute(cmd, '$basename', Quote(basename), 'g')
    let cmd = substitute(cmd, '$dirname', Quote(dirname), 'g')
    let cmd = substitute(cmd, '$ext', Quote(ext), 'g')
    let cmd = substitute(cmd, '$stem', Quote(stem), 'g')
    return cmd
endfunction

" }}} 2. CODE RUNNER


" let s:comp = 0
" set cot=menu,menuone,noinsert,noselect cpt-=u
" au insertcharpre * call I()
" au completedone * let s:comp = 0
" ino <expr> <tab> pumvisible() \|\| getline('.')[:col('.')-2] !~ '^\s*$' ? "\<c-n>" : "\<tab>"

" func I()  "InsertPre
"     if !pumvisible() && !s:comp && v:char =~ '\K'
"         let s:comp = 1
"         call feedkeys("\<c-n>")
"     end
" endf

