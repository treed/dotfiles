call pathogen#runtime_append_all_bundles()
set t_Co=256
syntax enable
set background=dark
colorscheme solarized
set nocompatible
set bs=2
set viminfo='20,\"500
set history=100
set ruler
set hidden
" I find highlighting on search terms distracting
set nohlsearch

" Remove GUI chrome
set go-=T
set go-=r
set go-=m
set go-=L

" Indentation options"
set ai
set tabstop=4
set shiftwidth=4
set expandtab

syntax on

" fix mouse scrolling
set t_Sb=^[4%dm
set t_Sf=^[3%dm
set ttymouse=xterm2

filetype plugin on

set grepprg=grep\ -nH\ $*

filetype indent on

" different tabbing semantics
vnoremap <C-T> >
vnoremap <C-D> <LT>
vmap <Tab> <C-T>
vmap <S-Tab> <C-D>
inoremap <Tab> <C-T>
inoremap <S-Tab> <C-D>

nnoremap \tp :set invpaste paste?<CR>
nmap <F4> \tp
imap <F4> <C-O> \tp
set pastetoggle=<F4>

" I like to have a faster way to go back after jumping around
nnoremap < <C-O>

" Make Ctrl-T increment the number of tests with Test::More
let @t = "/^\\s*plan<"
nnoremap <C-T> @t

" Common keypresses that I want to be fast to hit
let mapleader = " "
" Move around between splits
nnoremap <leader>h <C-W>h
nnoremap <leader>l <C-W>l
nnoremap <leader>j <C-W>j
nnoremap <leader>k <C-W>k
" Cycle through buffers in the current split
nnoremap <leader>n :bn<CR>
nnoremap <leader>p :bp<CR>
" Remove the current buffer without closing the window
nnoremap <leader>x :Kwbd<CR>
" Open various panels or whatever
nnoremap <leader>t :TagbarToggle<CR>
nnoremap <leader>r :NERDTreeToggle<CR>
nnoremap <leader>o :CommandT<CR>
" Don't remember, heh
nnoremap ' `
nnoremap ` '

set scrolloff=3

set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>s :set nolist!<CR>

autocmd BufNewFile,BufRead *.p6 setf perl6

helptags ~/.vim/doc
