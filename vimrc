call plug#begin()

" Plumbing
Plug 'tomtom/tlib_vim'
if has("unix")
    let s:uname = system("uname")
    if s:uname == "Darwin\n"
        Plug 'Shougo/vimproc.vim', { 'do': 'make -f make_mac.mak' }
    else
        Plug 'Shougo/vimproc.vim', { 'do': 'make -f make_unix.mak' }
    endif
endif

" Sane Behavior
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tommcdo/vim-exchange'
Plug 'vim-pandoc/vim-pandoc'
Plug 'sickill/vim-pasta'
Plug 'svermeulen/vim-easyclip'
Plug 'myusuf3/numbers.vim'
Plug 'ervandew/supertab'

" Utilities
Plug 'bling/vim-airline'
Plug 'mhinz/vim-signify'
Plug 'Valloric/YouCompleteMe', { 'do': './install.sh' }
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive'
Plug 'int3/vim-extradite'
Plug 'godlygeek/tabular'
Plug 'kien/rainbow_parentheses.vim'
Plug 'moll/vim-bbye'

" Colorschemes
Plug 'nanotech/jellybeans.vim'
Plug 'w0ng/vim-hybrid'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Panels
Plug 'Shougo/unite.vim'
Plug 'Shougo/neomru.vim'
Plug 'majutsushi/tagbar'
Plug 'sjl/gundo.vim', { 'on': 'GundoToggle' }
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'wincent/Command-T', { 'on': 'CommandTFlush', 'do': 'cd ruby/command-t && ruby extconf.rb && make' }

" Language-Specific
Plug 'fatih/vim-go'
Plug 'ClockworkNet/vim-junos-syntax', { 'for': 'junos' }
Plug 'vim-scripts/nginx.vim', { 'for': 'nginx' }
Plug 'dbakker/vim-lint', { 'for': 'vim' }
Plug 'vim-perl/vim-perl', { 'for': 'perl' }
Plug 'c9s/perlomni.vim', { 'for': 'perl' }
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

call plug#end()

" Woo Colors!
set t_Co=256
set background=dark
if has("gui_macvim")
    set guifont=Meslo\ LG\ M\ for\ Powerline:h14
    let g:hybrid_use_iTerm_colors = 1
elseif has("gui_running")
    set guifont=Inconsolata-dz\ for\ Powerline\ 12
endif
colorscheme hybrid
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
nnoremap <Space>e :Unite -no-split -buffer-name=buffer  buffer<cr>
" Remove the current buffer without closing the window
nnoremap <Space>x :Bdelete<CR>
" Open various panels or whatever
nnoremap <silent> <Space>t :TagbarToggle<CR>
nnoremap <silent> <Space>r :NERDTreeToggle<CR>
"nnoremap <Space>o :CommandTFlush<CR>:CommandT<CR>
nnoremap <Space>o :Unite -no-split -buffer-name=files   -start-insert file_rec/async:!<cr>
nnoremap <Space>u :GundoToggle<CR>
" Clear trailing whitespace and save
nnoremap <silent> <Space>w :%s/\s\+$//g<CR>:w<CR>
" Fast access to ag
nnoremap <Space>a :Unite -no-split -buffer-name=ag grep:.<CR>

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
autocmd FileType go setlocal noexpandtab

" Markdown Specific
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufNewFile,BufRead *.md setlocal spell spelllang=en_us

" Haskell Specific
autocmd BufNewFile,BufRead *.hs setlocal omnifunc=necoghc#omnifunc

set scrolloff=10

if executable('ag')
  set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
  set grepformat=%f:%l:%c:%m
  let g:unite_source_grep_command='ag'
  let g:unite_source_grep_default_opts='--nocolor --nogroup -S'
  let g:unite_source_grep_recursive_opt=''
elseif executable('ack')
  set grepprg=ack\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow\ $*
  set grepformat=%f:%l:%c:%m
else
  set grepprg=grep\ --exclude-dir\ .git\ -nrI\ $*\ .\ /dev/null
endif

let g:unite_source_file_rec_max_cache_files = 0
call unite#custom#source('file_mru,file_rec,file_rec/async,grepocate', 'max_candidates', 0)

" Need to associate p6 files, the plugin doesn't for some reason
autocmd BufNewFile,BufRead *.p6 setf perl6
autocmd BufNewFile,BufRead *.nel setf nel

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

let g:pandoc#formatting#smart_autoformat_on_cursor_moved = 1
let g:pandoc#formatting#mode="hA"
let g:pandoc#formatting#textwidth=80

let g:EasyClipUseSubstituteDefaults = 1

call airline#parts#define_function('goinfo', 'go#complete#GetInfo')
call airline#parts#define_condition('goinfo', '&ft =~ "go"')
function! AirlineInit()
    let g:airline_section_x = airline#section#create_right(['goinfo', 'tagbar', 'filetype'])
endfunction
autocmd VimEnter * call AirlineInit()
