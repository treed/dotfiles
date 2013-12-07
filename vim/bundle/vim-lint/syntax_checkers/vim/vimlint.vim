if exists('g:loaded_syntastic_vim_vimlint_checker')
  finish
endif
let g:loaded_syntastic_vim_vimlint_checker = 1

function! s:get_vimlint()
    if !exists('s:vimlint_exe')
        let paths = substitute(escape(&runtimepath, ' '), '\(,\|$\)', '/**\1', 'g')
        let s:vimlint_exe = findfile('vimlint.py', paths)
    endif
    return s:vimlint_exe
endfunction

function! SyntaxCheckers_vim_vimlint_IsAvailable()
  return executable('python') && filereadable(s:get_vimlint())
endfunction

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_vim_vimlint_GetLocList()
  let makeprg = syntastic#makeprg#build({
        \ 'exe': 'python '.s:get_vimlint(),
        \ 'filetype': 'vim',
        \ 'subchecker': 'vimlint' })

  let errorformat = 
        \ '%f:%l:%c: %trror: %m,' .
        \ '%f:%l:%c: %tarning: %m'

  " process makeprg
  let errors = SyntasticMake({ 'makeprg': makeprg,
        \ 'errorformat': errorformat })

  return errors
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
      \ 'filetype': 'vim',
      \ 'name': 'vimlint'})

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set et sts=4 sw=4:
