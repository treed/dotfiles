" vim doesn't like fish as a shell
if &shell =~# 'fish$'
    set shell=sh
endif

set ignorecase         " Ignore case in searching
set smartcase          " Ignore ignorecase if uppercase is used
set gdefault           " /g default on s//
set laststatus=2       " forces status on all the time
set number             " line numbers (see numbers.vim)
set cursorline         " show a line wherever the cursor is
set autoread           " automatically reread a file if it's been changed outside of vim
set list               " Shows otherwise invisible characters
set listchars=tab:╾─,eol:↩,trail:␠

" Indentation options
set ai
set tabstop=4
set shiftwidth=4
set expandtab

call plug#begin('~/.nvim/plugged')

""" Sane Behavior

Plug 'tpope/vim-repeat'                       " Lets you use . for more commands, and for plugins that support it
Plug 'tpope/vim-surround'                     " Adds objects for 'surroundings'
Plug 'svermeulen/vim-easyclip'                " Fixes copypasta in a variety of ways, not least of which is making d delete, not cut; m becomes 'move' instead
    let g:EasyClipUseSubstituteDefaults=1
    let g:EasyClipAutoFormat=1
Plug 'myusuf3/numbers.vim'                    " Switch to relnumber in visual/normal mode automatically
Plug 'haya14busa/incsearch.vim'               " Some niceties around searching
    map /  <Plug>(incsearch-forward)
    map ?  <Plug>(incsearch-backward)
    map g/ <Plug>(incsearch-stay)
    set hlsearch
    let g:incsearch#auto_nohlsearch = 1
    map n  <Plug>(incsearch-nohl-n)
    map N  <Plug>(incsearch-nohl-N)
    map *  <Plug>(incsearch-nohl-*)
    map #  <Plug>(incsearch-nohl-#)
    map g* <Plug>(incsearch-nohl-g*)
    map g# <Plug>(incsearch-nohl-g#)

""" Visual Improvements

Plug 'altercation/vim-colors-solarized'       " Solarized theme
    let g:solarized_contrast="high"
    let g:solarized_visibility="normal"
Plug 'bling/vim-airline'                      " Pimped-out status line
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline#extensions#branch#symbol = ''
    let g:airline#extensions#readonly#symbol = ''
    let g:airline_symbols.linenr = ''
    let g:airline#extensions#hunks#non_zero_only = 1
    let g:airline_theme="solarized"

""" Utilities

Plug 'junegunn/fzf'                           " Fuzzy finder
Plug 'Shougo/deoplete.nvim'                   " nvim-specific autocompletion
let g:deoplete#enable_at_startup = 1
Plug 'benekastah/neomake'                     " nvim-specific async 'make' running (syntax checking)
let g:neomake_json_enabled_makers = ['jsonlint']
autocmd! BufWritePost * Neomake
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

""" Language Specific

Plug 'Shougo/neco-vim'                        " autocompletion support for vimL

call plug#end()

colorscheme solarized

" I use space as a sort of personal leader
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

nnoremap <Space>o :FZF<CR>

function ToggleCopyMode()
    set list!
    set number!
    set relativenumber!
endfunction

nnoremap <F4> :set paste!<CR>
nnoremap <F5> :call ToggleCopyMode()<CR>
