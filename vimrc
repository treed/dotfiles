" Must come first
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
filetype plugin indent on

" Woo Colors!
set t_Co=256
let g:Powerline_symbols="unicode"
colorscheme desert
if has("gui_running")
    set guifont=Inconsolata-dz\ \ for\ Powerline\ 14
    let g:Powerline_symbols="fancy"
    set cursorline
    set background=dark
    colorscheme solarized
endif
syntax on

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

" different tab semantics
inoremap <Tab> <C-T>
inoremap <S-Tab> <C-D>
vnoremap <Tab> 1>
vnoremap <S-Tab> 1<
nnoremap <Tab> >>
nnoremap <S-Tab> <<

" I like to have a faster way to go back after jumping around
nnoremap < <C-O>
nnoremap > <C-I>

" Y should work like D
map Y y$

" Make Ctrl-T increment the number of tests with Test::More
nnoremap <silent> <C-T> :%s/plan tests => \zs\d\+/\=submatch(0) + 1/<CR><C-O>

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
nnoremap <Space>b :LustyBufferExplorer<CR>
" Remove the current buffer without closing the window
nnoremap <Space>x :Kwbd<CR>
" Open various panels or whatever
nnoremap <silent> <Space>t :TagbarToggle<CR>
nnoremap <silent> <Space>r :NERDTreeToggle<CR>
nnoremap <Space>o :CommandT<CR>
" Clear trailing whitespace and save
nnoremap <silent> <Space>w :%s/\s\+$//g<CR>:w<CR>
" Run perltidy
nnoremap <silent> <Space>c :%!perl perltidy.pl --profile=perltidyrc<CR>
vnoremap <silent> <Space>c :!perl perltidy.pl --profile=perltidyrc<CR>
" Fast access to Ack
nnoremap <Space>a :Ack! 

set scrolloff=10

" Need to associate p6 files, the plugin doesn't for some reason
autocmd BufNewFile,BufRead *.p6 setf perl6
autocmd BufNewFile,BufRead *.nel setf nel
autocmd BufNewFile,BufRead *.md set filetype=markdown

let g:CommandTMaxHeight=20
let g:CommandTMaxFiles=20000

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<space><space>"


helptags ~/.vim/doc
