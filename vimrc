runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
filetype plugin indent on

" Woo Colors!
set t_Co=256
let g:Powerline_symbols="fancy"
set background=dark
colorscheme inkpot
if has("gui_running")
    set guifont=Inconsolata-dz\ \ for\ Powerline\ 12
    let g:Powerline_symbols="fancy"
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
vnoremap <Tab> 1>
vnoremap <S-Tab> 1<
nnoremap <Tab> >>
nnoremap <S-Tab> <<

" I like to have a faster way to go back after jumping around
nnoremap < <C-O>
nnoremap > <C-I>

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
" Clear trailing whitespace and save
nnoremap <silent> <Space>w :%s/\s\+$//g<CR>:w<CR>
" Fast access to grep (used to be ack, hence the 'a')
nnoremap <Space>a :RGrep! 
" Fuzzy find
nnoremap <Space>/ :FufLine<CR>
" EasyMotion
let g:EasyMotion_leader_key = '<Space>.'

" Tabular.vim presets
vnoremap <silent> <Space>,$ :Tabularize /-\?\$/l2c0r0<CR>

" Perl Specific
" Make Ctrl-T increment the number of tests with Test::More
autocmd BufNewFile,BufRead *.t nnoremap <silent> <C-T> :%s/plan tests => \zs\d\+/\=submatch(0) + 1/<CR><C-O>
" Run perltidy
autocmd BufNewFile,BufRead *.p[lm] nnoremap <silent> <Space>c :%!perl perltidy.pl --profile=perltidyrc<CR>
autocmd BufNewFile,BufRead *.p[lm] vnoremap <silent> <Space>c :!perl perltidy.pl --profile=perltidyrc<CR>

" Go Specific
autocmd BufNewFile,BufRead *.go nnoremap <silent> <C-T> :call VimuxRunCommand("go test")<CR>
autocmd BufNewFile,BufRead *.go nnoremap <silent> <Space>c :Fmt<CR>

set scrolloff=10

set grepprg=grep\ --exclude-dir\ .git\ -nrI\ $*\ .\ /dev/null

" Need to associate p6 files, the plugin doesn't for some reason
autocmd BufNewFile,BufRead *.p6 setf perl6
autocmd BufNewFile,BufRead *.nel setf nel
autocmd BufNewFile,BufRead *.md set filetype=markdown

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

helptags ~/.vim/doc
