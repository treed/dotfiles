
"""""""""""""""""""""""
" Variables
"""""""""""""""""""""""
let s:activeRegister = EasyClip#GetDefaultReg()

"""""""""""""""""""""""
" Plugs
"""""""""""""""""""""""
nnoremap <silent> <plug>MoveMotionEndOfLinePlug :<c-u>EasyClipBeforeYank<cr>y$"_d$:call repeat#set("\<plug>MoveMotionEndOfLinePlug")<cr>
nnoremap <silent> <plug>MoveMotionReplaceLinePlug :<c-u>EasyClipBeforeYank<cr>0y$"_d$:call repeat#set("\<plug>MoveMotionReplaceLinePlug")<cr>
nnoremap <silent> <expr> <plug>MoveMotionLinePlug ':<c-u>EasyClipBeforeYank<cr>'. v:count .'yy'. v:count . '"_dd:call repeat#set("\<plug>MoveMotionLinePlug")<cr>'
xnoremap <silent> <plug>MoveMotionXPlug :<c-u>EasyClipBeforeYank<cr>gvygv"_d
nnoremap <silent> <plug>MoveMotionPlug :call EasyClip#Move#PreMoveMotion()<cr>:set opfunc=EasyClip#Move#MoveMotion<cr>g@

"""""""""""""""""""""""
" Functions
"""""""""""""""""""""""
function! EasyClip#Move#PreMoveMotion( )
    let s:activeRegister = v:register

    " This is necessary to get around a bug in vim where the active register persists to
    " the next command. Repro by doing "_d and then a command that uses v:register
    if s:activeRegister ==# "_"
        let s:activeRegister = EasyClip#GetDefaultReg( )
    endif
endfunction

function! EasyClip#Move#MoveMotion(type)

    if &selection ==# 'exclusive'
      let excl_right = "\<right>"
    else
      let excl_right = ""
    endif

    EasyClipBeforeYank
    let selectType = (a:type ==# 'line' ? "'[V']".excl_right : "`[v`]".excl_right)
    exe "keepjumps normal! ". selectType . "\"".s:activeRegister."y"

    exec "normal! gv"
    exec "normal! \"_d"
endfunction

function! EasyClip#Move#SetDefaultBindings()

    let bindings = 
    \ [
    \   ['m',  '<Plug>MoveMotionPlug',  'n',  1],
    \   ['mm',  '<Plug>MoveMotionLinePlug',  'n',  1],
    \   ['m',  '<Plug>MoveMotionXPlug',  'x',  1],
    \ ]

    " Leave these commented to avoid shadowing M (go to middle of screen)
    "\   ['M',  '<Plug>MoveMotionEndOfLinePlug',  'n',  1],
    "\   ['mM',  '<Plug>MoveMotionReplaceLinePlug',  'n',  1],

    for binding in bindings
        call call("EasyClip#AddWeakMapping", binding)
    endfor
endfunction

function! EasyClip#Move#Init()

    if g:EasyClipUseCutDefaults
        call EasyClip#Move#SetDefaultBindings()
    endif
endfunction
