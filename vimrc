if &shell =~# 'fish$'
    set shell=sh
endif

source ~/.vimrc-plugins
call unite#custom#source('file_mru,file_rec,file_rec/async,grepocate', 'max_candidates', 0)
call unite#custom#source('file_rec,file_rec/async', 'matchers', ['matcher_fuzzy'])
call unite#custom#source('buffer,file,file_mru,file_rec,file_rec/async', 'sorters', 'sorter_length')

" Woo Colors!
set t_Co=256
set background=light
if has("gui_macvim")
    set guifont=Meslo\ LG\ M\ for\ Powerline:h14
    let g:hybrid_use_iTerm_colors = 1
elseif has("gui_running")
    set guifont=Inconsolata-dz\ for\ Powerline\ 12
endif
colorscheme solarized
syntax on

" Various Options
set nocompatible
set bs=2
set viminfo='20,\"500
set history=100
set ruler
set hidden
set backspace=indent,eol,start " Backspace over linebreaks
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
set number
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
map Y y$

" Open a new split
nnoremap <silent> <Space>s :sp<CR>
nnoremap <silent> <Space>v :vsp<CR>
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
nnoremap <Space>e :Unite -no-split -buffer-name=buffer  buffer<cr>
" Remove the current buffer without closing the window
nnoremap <Space>x :Bdelete<CR>
" Open various panels or whatever
nnoremap <silent> <Space>t :TagbarToggle<CR>
nnoremap <silent> <Space>r :NERDTreeToggle<CR>
nnoremap <silent> <Space>c :LOTRToggle<CR>
nnoremap <Space>o :FZF<CR>
nnoremap <Space>u :GundoToggle<CR>
" Clear trailing whitespace and save
nnoremap <silent> <Space>w :%s/\s\+$//g<CR>:w<CR>
" Fast access to ag
nnoremap <Space>a :Unite -no-split -buffer-name=ag grep:.<CR>

vnoremap <silent> <Space>,$ :EasyAlign /-\?\$/l2<CR>

vmap <Enter> <Plug>(EasyAlign)

" Perl Specific
" Make Ctrl-T increment the number of tests with Test::More
autocmd BufNewFile,BufRead *.p[lm] nnoremap <silent> <C-T> :call VimuxRunCommand("sh bb_test.t")<CR>

" Run perltidy
autocmd BufNewFile,BufRead *.p[lm] nnoremap <silent> <Space>c :%!perl perltidy.pl --profile=perltidyrc<CR>
autocmd BufNewFile,BufRead *.p[lm] vnoremap <silent> <Space>c :!perl perltidy.pl --profile=perltidyrc<CR>

" Go Specific
autocmd FileType go nnoremap <buffer><silent> <C-T> :GolangTestCurrentPackage<CR>
autocmd FileType go nnoremap <buffer><silent> <Space>c :GoFmt<CR>
autocmd FileType go setlocal noexpandtab

" Markdown Specific
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufNewFile,BufRead *.md setlocal spell spelllang=en_us

" Haskell Specific
autocmd BufNewFile,BufRead *.hs setlocal omnifunc=necoghc#omnifunc

" JS Specific
autocmd FileType javascript nnoremap <buffer><silent> <Space>c :call JsBeautify()<CR>

set scrolloff=10

" Need to associate p6 files, the plugin doesn't for some reason
autocmd BufNewFile,BufRead *.p6 setf perl6
autocmd BufNewFile,BufRead *.nel setf nel

function! s:GoLint()
    cexpr system("golint " . shellescape(expand('%')))
    copen
endfunction
command! GoLint :call s:GoLint()
