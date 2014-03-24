" A lot of this is based on yankstack by Max Brunsfeld
" See originally code here: https://github.com/maxbrunsfeld/vim-yankstack

"""""""""""""""""""""""
" Variables
"""""""""""""""""""""""
let s:activeRegister = EasyClip#GetDefaultReg()
let s:yankstackTail = []
let s:isFirstYank = 1
let s:preYankPos = []
let s:yankCount = 0
let s:lastSystemClipboard = ''

"""""""""""""""""""""""
" Commands
"""""""""""""""""""""""
command! EasyClipBeforeYank :call EasyClip#Yank#OnBeforeYank()
command! -nargs=0 Yanks call EasyClip#Yank#ShowYanks()
command! -nargs=0 ClearYanks call EasyClip#Yank#ClearYanks()

"""""""""""""""""""""""
" Plugs
"""""""""""""""""""""""
nnoremap <plug>EasyClipRotateYanksForward :<c-u>call EasyClip#Yank#ManuallyRotateYanks(1)<cr>
nnoremap <plug>EasyClipRotateYanksBackward :<c-u>call EasyClip#Yank#ManuallyRotateYanks(-1)<cr>

nnoremap <silent> <plug>YankLinePreserveCursorPosition :<c-u>call EasyClip#Yank#PreYankMotion()<cr>:call EasyClip#Yank#YankLine()<cr>
nnoremap <silent> <plug>YankPreserveCursorPosition :<c-u>call EasyClip#Yank#PreYankMotion()<cr>:set opfunc=EasyClip#Yank#YankMotion<cr>g@

"""""""""""""""""""""""
" Functions
"""""""""""""""""""""""
function! EasyClip#Yank#EasyClipGetNumYanks()
    return len(s:yankstackTail) + 1
endfunction

function! EasyClip#Yank#OnBeforeYank()
    if s:isFirstYank
        let s:isFirstYank = 0
        return
    endif

    let head = EasyClip#Yank#GetYankstackHead()

    if !empty(head.text) && (empty(s:yankstackTail) || (head != s:yankstackTail[0]))
        call insert(s:yankstackTail, head)
        let s:yankstackTail = s:yankstackTail[: g:EasyClipYankHistorySize-1]
    endif

    call s:OnYankBufferChanged()
endfunction

function! s:OnYankBufferChanged()
    for i in range(1, min([len(s:yankstackTail), 9]))
        let entry = s:yankstackTail[i-1]

        call setreg(i, entry.text, entry.type)
    endfor
endfunction

function! EasyClip#Yank#Rotate(offset)

    if empty(s:yankstackTail)
        return
    endif

    let offset_left = a:offset

    while offset_left != 0
        let head = EasyClip#Yank#GetYankstackHead()

        if offset_left > 0
            let entry = remove(s:yankstackTail, 0)
            call add(s:yankstackTail, head)
            let offset_left -= 1
        elseif offset_left < 0
            let entry = remove(s:yankstackTail, -1)
            call insert(s:yankstackTail, head)
            let offset_left += 1
        endif

        call EasyClip#Yank#SetYankStackHead(entry)
    endwhile

    call s:OnYankBufferChanged()
endfunction

function! EasyClip#Yank#ClearYanks()
    let s:yankstackTail = []
    let s:isFirstYank = 1
endfunction

function! EasyClip#Yank#GetYankstackHead()
    let reg = EasyClip#GetDefaultReg()

    return { 'text': getreg(reg), 'type': getregtype(reg) }
endfunction

function! EasyClip#Yank#SetYankStackHead(entry)
    let reg = EasyClip#GetDefaultReg()
    call setreg(reg, a:entry.text, a:entry.type)
endfunction

function! EasyClip#Yank#ShowYanks()
    echohl WarningMsg | echo "--- Yanks ---" | echohl None
    let i = 0
    for yank in EasyClip#Yank#EasyClipGetAllYanks()
        call EasyClip#Yank#ShowYank(yank, i)
        let i += 1
    endfor
endfunction

function! EasyClip#Yank#ShowYank(yank, index)
    let index = printf("%-4d", a:index)
    let line = substitute(a:yank.text, '\V\n', '^M', 'g')

    if len(line) > 80
        let line = line[: 80] . '…'
    endif

    echohl Directory | echo  index
    echohl None      | echon line
    echohl None
endfunction

function! EasyClip#Yank#PreYankMotion()
    let s:yankCount = v:count > 0 ? v:count : 1
    let s:activeRegister = v:register

    " This is necessary to get around a bug in vim where the active register persists to
    " the next command. Repro by doing "_d and then a command that uses v:register
    if s:activeRegister ==# "_"
        let s:activeRegister = EasyClip#GetDefaultReg()
    endif

    let s:preYankPos = getpos('.')
endfunction

function! EasyClip#Yank#YankMotion(type)
    if &selection ==# 'exclusive'
      let excl_right = "\<right>"
    else
      let excl_right = ""
    endif

    EasyClipBeforeYank

    let oldVisualStart = getpos("'<")
    let oldVisualEnd = getpos("'>")

    if a:type ==# 'line'
        exe "keepjumps normal! `[V`]".excl_right."\"".s:activeRegister."y"
    elseif a:type ==# 'char'
        exe "keepjumps normal! `[v`]".excl_right."\"".s:activeRegister."y"
    else
        echom "Unexpected selection type"
        return
    endif

    call setpos("'<", oldVisualStart)
    call setpos("'>", oldVisualEnd)

    if g:EasyClipPreserveCursorPositionAfterYank && !empty(s:preYankPos)
        call setpos('.', s:preYankPos)
        let s:preYankPos = []
        " This is necessary for some reason otherwise if you go down a line it will
        " jump to the column where the yank normally positions the cursor by default
        " To repro just remove this line, run yiq inside quotes, then go down a line
        if col('.') == col('$')-1
            normal! hl
        else
            normal! lh
        endif
    endif
endfunction

function! EasyClip#Yank#YankLine()
    EasyClipBeforeYank
    exec 'normal! '. s:yankCount . '"'. s:activeRegister .'yy'

    call setpos('.', s:preYankPos)
endfunction

function! EasyClip#Yank#EasyClipGetAllYanks()
    return [EasyClip#Yank#GetYankstackHead()] + s:yankstackTail
endfunction

function! EasyClip#Yank#ManuallyRotateYanks(offset)

    call EasyClip#Yank#Rotate(a:offset)
    echo "Current Yank: " . split(EasyClip#Yank#GetYankstackHead().text, '\n')[0] . "..."
endfunction

function! EasyClip#Yank#SetDefaultMappings()

    let bindings = 
    \ [
    \   ['[y',  '<plug>EasyClipRotateYanksForward',  'n',  1],
    \   [']y',  '<plug>EasyClipRotateYanksBackward',  'n',  1],
    \   ['Y',  ':EasyClipBeforeYank<cr>y$',  'n',  0], 
    \   ['y',  '<Plug>YankPreserveCursorPosition',  'n',  1],
    \   ['yy',  '<Plug>YankLinePreserveCursorPosition',  'n',  1],
    \ ]

    for binding in bindings
        call call("EasyClip#AddWeakMapping", binding)
    endfor

    xnoremap <silent> <expr> y ':<c-u>EasyClipBeforeYank<cr>gv"'. v:register . 'y'
endfunction

function! EasyClip#Yank#OnFocusLost()
    let s:lastSystemClipboard = @*
endfunction

" Just automatically copy system clipboard to the default
" register
function! EasyClip#Yank#OnFocusGained()
    if s:lastSystemClipboard !=# @*
        EasyClipBeforeYank
        let s:lastSystemClipboard = @*
        exec 'let @'. EasyClip#GetDefaultReg() .' = @*'
    endif
endfunction

function! EasyClip#Yank#InitSystemSync()

    " Check whether the system clipboard changed while focus was lost and 
    " add it to our yank buffer
    augroup _sync_clipboard
        au!
        autocmd FocusGained * call EasyClip#Yank#OnFocusGained()
        autocmd FocusLost * call EasyClip#Yank#OnFocusLost()
    augroup END
endfunction

function! EasyClip#Yank#Init()

    if g:EasyClipUseYankDefaults
        call EasyClip#Yank#SetDefaultMappings()
    endif

    if g:EasyClipDoSystemSync
        call EasyClip#Yank#InitSystemSync()
    endif
endfunction

