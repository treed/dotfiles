if &shell =~# 'fish$'
    set shell=sh
endif

set termguicolors

call plug#begin('~/.config/nvim/plugged')

Plug 'thinca/vim-prettyprint'
Plug 'tpope/vim-repeat'
Plug 'cloudhead/neovim-fuzzy'
Plug 'vim-airline/vim-airline'
	let g:airline_powerline_fonts = 1
Plug 'vim-airline/vim-airline-themes'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	let g:deoplete#enable_at_startup = 1
	let g:deoplete#enable_smart_case = 1
Plug 'zchee/deoplete-go', { 'do': 'make' }
Plug 'SirVer/ultisnips'
	let g:UltiSnipsSnippetsDir = "/Users/treed/.config/nvim/UltiSnips"

Plug 'fatih/vim-go'
Plug 'rust-lang/rust.vim'
	let g:rustfmt_autosave = 1
Plug 'racer-rust/vim-racer'
Plug 'rakr/vim-one'
Plug 'moll/vim-bbye'
Plug 'neomake/neomake'
	let g:neomake_error_sign = {'text': '>>', 'texthl': 'ErrorMsg'}
	let g:neomake_warning_sign = {'text': '>>', 'texthl': 'WarningMsg'}
	let g:neomake_open_list = 2
	let g:neomake_go_enabled_makers = ['go', 'golint', 'govet']
	autocmd! BufWritePost * Neomake
Plug 'Shougo/denite.nvim'
Plug 'Shougo/echodoc.vim'

Plug 'svermeulen/vim-easyclip'
	let g:EasyClipUseSubstituteDefaults = 1
	let g:EasyClipAutoFormat = 1

Plug 'tpope/vim-fugitive'
Plug 'int3/vim-extradite'
Plug 'haya14busa/incsearch.vim'
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

Plug 'mhinz/vim-signify'
Plug 'vim-pandoc/vim-pandoc'
	let g:pandoc#formatting#smart_autoformat_on_cursor_moved = 1
	let g:pandoc#formatting#mode="hA"
	let g:pandoc#formatting#textwidth=80
	let g:pandoc#modules#disabled = ["folding"]
Plug 'vim-pandoc/vim-pandoc-syntax'

call plug#end()

" The tab handling stuff is mostly cribbed from https://github.com/simonweil/dotfiles

" Don't map any tabs, I'll do it later
let g:UltiSnipsExpandTrigger = '<NOP>'
let g:UltiSnipsJumpForwardTrigger = '<NOP>'
let g:UltiSnipsJumpBackwardTrigger = '<NOP>'
" Don't unmap my mappings
let g:UltiSnipsMappingsToIgnore = [ "SmartTab", "SmartShiftTab" ]


" Ripgrep command on grep source
call denite#custom#var('grep', 'command', ['rg'])
call denite#custom#var('grep', 'default_opts', ['--vimgrep', '--no-heading'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Make <CR> smart
let g:ulti_expand_res = 0
function! Ulti_ExpandOrEnter()
	call UltiSnips#ExpandSnippet()
	if g:ulti_expand_res == 1
		" if successful, just return
		return ''
	elseif pumvisible()
		" if in completion menu - just close it and leave the cursor at the
		" end of the completion
		return deoplete#mappings#close_popup()
	else
		" otherwise, just do an "enter"
		return "\<return>"
	endif
endfunction
inoremap <return> <C-R>=Ulti_ExpandOrEnter()<CR>

" Enable tabbing and shift-tabbing through list of results
let g:ulti_jump_forwards_res = 0
function! g:SmartTab()
	if pumvisible()
		return "\<c-n>"
	else
		" If there's nothing to expand, just tab
		if strpart(getline('.'), col('.')-1, 2)  =~ '^\w*$'
			return "\<tab>"
		endif
		call UltiSnips#JumpForwards()
		if g:ulti_jump_forwards_res == 0
			return "\<tab>"
		endif
		return ''
	endif
endfunction
inoremap <silent> <tab> <C-R>=g:SmartTab()<cr>

function! g:SmartShiftTab()
	if pumvisible()
		return "\<c-p>"
	else
		call UltiSnips#JumpBackwards()
		if g:ulti_jump_backwards_res == 0
			return "\<c-p>"
		endif
		return ''
	endif
endfunction
inoremap <silent> <s-tab> <C-R>=g:SmartShiftTab()<cr>

nnoremap <silent> <Space>o :FuzzyOpen<CR>

" Window control
nnoremap <silent> <Space>ws :sp<CR>
nnoremap <silent> <Space>wv :vsp<CR>
nnoremap <Space>wh <C-W>h
nnoremap <Space>wl <C-W>l
nnoremap <Space>wj <C-W>j
nnoremap <Space>wk <C-W>k
nnoremap <Space>wc :q<CR>

" Buffer control
nnoremap <Space>bn :bn<CR>
nnoremap <Space>bp :bp<CR>
nnoremap <Space>bd :Bdelete<CR>

" Errors
map <Space>en :lnext<CR>
map <Space>ep :lprevious<CR>
nnoremap <Space>ec :lclose<CR>

" Git
map <Space>gs :Gstatus<CR>
map <Space>gc :Gcommit<CR>
map <Space>gb :Gblame<CR>
map <Space>gdc :Git svn dcommit<CR>
map <Space>gr :Git svn rebase<CR>
map <Space>gt :Extradite<CR>

" Search
map <Space>a :Denite -no-empty grep<CR>

set background=light
colorscheme one

set mouse=a
set grepprg=rg\ --vimgrep
set list
set listchars=tab:╾─,eol:↩,trail:␠
set cursorline
set number
set relativenumber
set noshowmode
set completeopt-=preview


