call pathogen#runtime_append_all_bundles()
set t_Co=256
colorscheme	inkpot
set nocompatible
set bs=2
set viminfo='20,\"500
set history=100
set ruler
set hidden

set go-=T
set go-=r
set go-=m
set go-=L

set ai
set tabstop=4
set shiftwidth=4
set expandtab

syntax on
set nohlsearch

set t_Sb=^[4%dm
set t_Sf=^[3%dm
set ttymouse=xterm2

filetype plugin on

set grepprg=grep\ -nH\ $*

filetype indent on

vnoremap <C-T> >
vnoremap <C-D> <LT>
vmap <Tab> <C-T>
vmap <S-Tab> <C-D>

nnoremap \tp :set invpaste paste?<CR>
nmap <F4> \tp
imap <F4> <C-O> \tp
set pastetoggle=<F4>

inoremap <Tab> <C-T>
inoremap <S-Tab> <C-D>
nnoremap d "_d
nnoremap < <C-O>

let @t = "/^\\s*plan<"
nnoremap <C-T> @t
let mapleader = " "
nnoremap <leader>n :bn
nnoremap <leader>p :bp
nnoremap <leader>h h
nnoremap <leader>l l
nnoremap <leader>j j
nnoremap <leader>k k
nnoremap <leader>x :Kwbd
nnoremap ' `
nnoremap ` '

set scrolloff=3

set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>s :set nolist!<CR>

autocmd BufNewFile,BufRead *.p6 setf perl6

helptags ~/.vim/doc
