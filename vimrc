runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
filetype plugin indent on

" Woo Colors!
set t_Co=256
set background=dark
if has("gui_macvim")
    colorscheme jellybeans
elseif has("gui_running")
    set guifont=Inconsolata-dz\ \ for\ Powerline\ 12
    colorscheme jellybeans
else
    colorscheme jellybeans-approx
endif
syntax on

highlight DiffAdd term=reverse cterm=bold ctermbg=green ctermfg=white
highlight DiffChange term=reverse cterm=bold ctermbg=cyan ctermfg=black
highlight DiffText term=reverse cterm=bold ctermbg=gray ctermfg=black
highlight DiffDelete term=reverse cterm=bold ctermbg=red ctermfg=black

" Various Options
set nocompatible
set bs=2
set viminfo='20,\"500
set history=100
set ruler
set hidden
set encoding=utf-8
set laststatus=2
if version >= 703
    set undofile
    set undodir=~/.vimundo/,/var/tmp
endif
set backupdir=~/.vimbackup/,/var/tmp
set directory=~/.vimswap/,/var/tmp
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set nohlsearch
set cursorline
set autoread
autocmd CursorHold * checktime

set list
set listchars=tab:╾─,eol:↩,trail:␠

" Set GUI options: use console mode for dialogs, and enable X11 copying from
" VISUAL mode
set guioptions=ca

" Indentation options
set ai
set tabstop=4
set shiftwidth=4
set expandtab

" fix mouse scrolling
set ttymouse=xterm2
set mouse=a

" different tab semantics
let g:SuperTabDefaultCompletionType = "<c-x><c-o>"
set ofu=syntaxcomplete#Complete
set completeopt=longest,menu
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
nnoremap <Tab> >>
nnoremap <S-Tab> <<

" I like to have a faster way to go back after jumping around
nnoremap < <C-O>
nnoremap > <C-I>

" Resize splits
nnoremap <C-J> <C-W>+<CR>
nnoremap <C-K> <C-W>-<CR>

" Y should work like D
call yankstack#setup()
map Y y$

" Open a new split
nnoremap <silent> <Space>s :sp<CR>
" Close
nnoremap <silent> <Space>q :q<CR>
" Move around between splits
nnoremap <Space>h <C-W>h
nnoremap <Space>l <C-W>l
nnoremap <Space>j <C-W>j
nnoremap <Space>k <C-W>k
" Cycle through buffers in the current split
nnoremap <Space>n :bn<CR>
nnoremap <Space>p :bp<CR>
" Quick buffer list
nnoremap <Space>e :CommandTBuffer<CR>
" Remove the current buffer without closing the window
nnoremap <Space>x :Kwbd<CR>
" Open various panels or whatever
nnoremap <silent> <Space>t :TagbarToggle<CR>
nnoremap <silent> <Space>r :NERDTreeToggle<CR>
nnoremap <Space>o :CommandTFlush<CR>:CommandT<CR>
nnoremap <Space>u :GundoToggle<CR>
" Clear trailing whitespace and save
nnoremap <silent> <Space>w :%s/\s\+$//g<CR>:w<CR>
" Fast access to grep (used to be ack, hence the 'a')
nnoremap <Space>a :RGrep!
" Fuzzy find
nnoremap <Space>i :FufLine<CR>
" EasyMotion
let g:EasyMotion_leader_key = '<Space>.'

" Tabular.vim presets
vnoremap <silent> <Space>,$ :Tabularize /-\?\$/l2c0r0<CR>

" Perl Specific
" Make Ctrl-T increment the number of tests with Test::More
autocmd BufNewFile,BufRead *.p[lm] nnoremap <silent> <C-T> :call VimuxRunCommand("sh bb_test.t")<CR>

" Run perltidy
autocmd BufNewFile,BufRead *.p[lm] nnoremap <silent> <Space>c :%!perl perltidy.pl --profile=perltidyrc<CR>
autocmd BufNewFile,BufRead *.p[lm] vnoremap <silent> <Space>c :!perl perltidy.pl --profile=perltidyrc<CR>

" Go Specific
autocmd FileType go nnoremap <buffer><silent> <C-T> :call VimuxRunCommand("go test")<CR>
autocmd FileType go nnoremap <buffer><silent> <Space>c :Fmt<CR>
autocmd FileType go setlocal noexpandtab
autocmd FileType go autocmd BufWritePre <buffer> execute "normal! mz:mkview\<esc>:Fmt\<esc>:loadview\<esc>`z"

" Markdown Specific
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufNewFile,BufRead *.md setlocal spell spelllang=en_us

" Haskell Specific
autocmd BufNewFile,BufRead *.hs setlocal omnifunc=necoghc#omnifunc

set scrolloff=10

set grepprg=grep\ --exclude-dir\ .git\ -nrI\ $*\ .\ /dev/null

" Need to associate p6 files, the plugin doesn't for some reason
autocmd BufNewFile,BufRead *.p6 setf perl6
autocmd BufNewFile,BufRead *.nel setf nel

"avoiding annoying CSApprox warning message
let g:CSApprox_verbose_level = 0

let g:CommandTMaxHeight=20
let g:CommandTMaxFiles=20000

let g:syntastic_auto_loc_list=1

let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
    \ }

let g:ycm_filetype_blacklist = {
  \   'unite': 1,
  \ }

let g:ycm_semantic_triggers =  {
  \   'c' : ['->', '.'],
  \   'objc' : ['->', '.'],
  \   'cpp,objcpp' : ['->', '.', '::'],
  \   'perl' : ['->'],
  \   'php' : ['->', '::'],
  \   'cs,java,javascript,d,vim,ruby,python,perl6,scala,vb,elixir,go' : ['.'],
  \   'lua' : ['.', ':'],
  \   'erlang' : [':'],
  \   'haskell' : ['.'],
  \ }

function! s:GoLint()
    cexpr system("golint " . shellescape(expand('%')))
    copen
endfunction
command! GoLint :call s:GoLint()

let g:haddock_browser = ""
let g:haddock_docdir = ""

let g:ycm_key_list_select_completion = ['<C-j>']
let g:ycm_key_list_previous_completion = ['<C-k>']
let g:ycm_key_list_invoke_completion = ['<tab>']
let g:UltiSnipsExpandTrigger="<tab>"

function! g:UltiSnips_Complete()
    call UltiSnips_ExpandSnippet()
    if g:ulti_expand_res == 0
        if pumvisible()
            return "\<C-n>"
        else
            call UltiSnips_JumpForwards()
            if g:ulti_jump_forwards_res == 0
               return "\<TAB>"
            endif
        endif
    endif
    return ""
endfunction

au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"

call unite#custom_source('file_rec,file_rec/async', 'matchers', ['matcher_fuzzy'])
call unite#custom_source('buffer,file,file_mru,file_rec,file_rec/async', 'sorters', 'sorter_length')
let g:unite_force_overwrite_statusline = 0

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline#extensions#branch#symbol = ''
let g:airline#extensions#readonly#symbol = ''
let g:airline_linecolumn_prefix = ''
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline_theme="bubblegum"

let g:signify_cursorhold_normal = 1

helptags ~/.vim/doc
