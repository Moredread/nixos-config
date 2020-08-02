call plug#begin('~/.vim/plugged')

Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-sensible'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf'


if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-github-dashboard'
" Plug 'terryma/vim-multiple-cursors'
Plug 'sjl/gundo.vim'
Plug 'tpope/vim-fugitive'
Plug 'plasticboy/vim-markdown'
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'LnL7/vim-nix'
Plug 'luochen1990/rainbow'
Plug 'scrooloose/nerdcommenter'
Plug 'dbeniamine/todo.txt-vim'
"Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'xolox/vim-lua-ftplugin'
Plug 'daveyarwood/vim-alda'
Plug 'dylanaraps/wal.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'ledger/vim-ledger'
"Plug '~/.nix-profile/share/vim-plugins/youcompleteme'



" External tool integration
Plug 'editorconfig/editorconfig-vim'
Plug 'jremmen/vim-ripgrep'
Plug 'junegunn/fzf'
Plug 'tpope/vim-fugitive'

" IDE-like features
Plug 'bronson/vim-trailing-whitespace'
Plug 'dense-analysis/ale'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-commentary'
Plug 'vim-test/vim-test'
Plug 'tpope/vim-eunuch'

Plug 'supercollider/scvim'

call plug#end()

let g:lua_check_syntax = 0
let g:lua_complete_omni = 1
let g:lua_complete_dynamic = 0
let g:lua_define_completion_mappings = 0

call deoplete#custom#var('omni', 'functions', {
\ 'lua': 'xolox#lua#omnifunc',
\ })

augroup filetype_rust
    autocmd!
    autocmd BufReadPost *.rs setlocal filetype=rust
augroup END

set signcolumn=yes

set hidden
let $RUST_BACKTRACE = 1
let g:LanguageClient_loggingLevel = 'INFO'
let g:LanguageClient_virtualTextPrefix = ''
let g:LanguageClient_loggingFile =  expand('~/.local/share/nvim/LanguageClient.log')
let g:LanguageClient_serverStderr = expand('~/.local/share/nvim/LanguageServer.log')

" Smart home
noremap <expr> <silent> <Home> col('.') == match(getline('.'),'\S')+1 ? '0' : '^'
imap <silent> <Home> <C-O><Home>

" Wild menu
set wildmenu
set wildmode=longest,list,full

" Always show status bar
set laststatus=2

" Backspace
set backspace=indent,eol,start

" Markdown plugin
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_toml_frontmatter = 1

" Fuzzy finder binding
nmap ,e :call fzf#run({'sink': 'edit'})<CR>
nmap ,E :call fzf#run({'sink': 'edit', 'source': 'fd --hidden'})<CR>
nmap ,t :call fzf#run({'sink': 'tabedit'})<CR>
nmap ,T :call fzf#run({'sink': 'tabedit', 'source': 'fd --hidden'})<CR>

let g:ale_hover_to_preview = 1
"call deoplete#custom#option('sources', {
"		\ '_': ['buffer', 'ale'],
"		\})
" ALE options for linting
let g:ale_sign_column_always = 1
let g:ale_sign_error = '>'
let g:ale_sign_warning = '~'
let g:ale_rust_cargo_check_tests = 1
let g:ale_fixers = {
      \'*': ['remove_trailing_lines', 'trim_whitespace'],
      \'rust': ['rustfmt'],
      \'php': ['php_cs_fixer'],
      \}
nmap ,f :ALEFix<CR>

" UltiSnips options
inoremap <c-x><c-k> <c-x><c-k>
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<c-j>'
let g:UltiSnipsJumpBackwardTrigger='<c-k>'
let g:UltiSnipsEditSplit='vertical'
nmap ,s :UltiSnipsEdit<CR>

" colorscheme wal
set background=dark
colorscheme solarized

let g:ycm_server_log_level = 'debug'
let g:ycm_max_diagnostics_to_display = 0

au BufEnter,BufWinEnter,BufNewFile,BufRead *.sc,*.scd set filetype=supercollider
au Filetype supercollider packadd scvim

let g:LanguageClient_serverCommands = {
      \ 'nix': ['nix-lsp'],
      \ 'python': ['pyls'],
      \ 'rust': ['rls'],
      \ 'lua': ['lua-lsp'],
      \ }
let g:LanguageClient_loadSettings = 1
nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> gh :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> gr :call LanguageClient_textDocument_references()<CR>
nnoremap <silent> gs :call LanguageClient_textDocument_documentSymbol()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
nnoremap <silent> gf :call LanguageClient_textDocument_formatting()<CR>

let g:deoplete#enable_at_startup = 1
let g:scFlash = 1

let g:fzf_buffers_jump = 1

let g:rainbow_active = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1

let g:EditorConfig_exclude_patterns = ['fugitive://.*']

"was given by linux distro
runtime! debian.vim

command W :execute ':silent w !sudo tee % > /dev/null' | :edit!

"enable colors for syntax
syntax enable

set statusline="%wc:%{WordCount()} {fugitive#statusline()}"

" Display cursorline
set cursorline

" Color of the Cursorline
hi CursorLine guibg=Grey9

" Color of the tabline
hi TabLine term=underline cterm=bold ctermfg=green ctermbg=black

" Set encoding to utf-8
if has("multi_byte")
  set encoding=utf-8
  setglobal fileencoding=utf-8
  set fileencodings=ucs-bom,utf-8,latin1
endif

" For searching
set ignorecase
set incsearch
set hlsearch

set tabstop=2
set expandtab
set shiftwidth=2
set softtabstop=2
" for Makefiles
" added some special formatting in Makefiles
autocmd BufEnter ?akefile* set noet ts=8 sw=8 nocindent list lcs=tab:>-,trail:x

filetype plugin indent on

au BufRead,BufNewFile SConstruct set filetype=python
au FileType python setlocal textwidth=0 tabstop=4 shiftwidth=4 softtabstop=4

map <C-q> gwap

function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

set textwidth=80

function WordCount()
  let s:old_status = v:statusmsg
  exe "silent normal g\<c-g>"
  let s:word_count = str2nr(split(v:statusmsg)[11])
  let v:statusmsg = s:old_status
  return s:word_count
endfunction

" show what's over 80 on a line
" from http://vim.wikia.com/wiki/Highlight_long_lines
" might be replaced by new command colorcolumn
nnoremap <silent> <Leader>l
      \ :if exists('w:long_line_match') <Bar>
      \   silent! call matchdelete(w:long_line_match) <Bar>
      \   unlet w:long_line_match <Bar>
      \ elseif &textwidth > 0 <Bar>
      \   let w:long_line_match = matchadd('ErrorMsg', '\%>'.&tw.'v.\+', -1) <Bar>
      \ else <Bar>
      \   let w:long_line_match = matchadd('ErrorMsg', '\%>80v.\+', -1) <Bar>
      \ endif<CR>

set mouse=a
set clipboard=unnamed,unnamedplus

au BufEnter *.tex set nosmartindent
set mousemodel=popup_setpos
set spell spelllang=en_us

" Let's save undo info!
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undodir")
    call mkdir($HOME."/.vim/undodir", "", 0700)
endif

set undodir=~/.vim/undodir
set undofile
au BufWritePre /tmp/* setlocal noundofile
au BufWritePre /dev/shm/* setlocal noundofile

nnoremap <F3> :GundoToggle<CR>
nnoremap <F4> :browse confirm wa<CR>

set number
set hidden
"let g:racer_cmd = "racer"

"set virtualedit=all

nnoremap <F3> :Autoformat<CR>
"au BufWrite * :Autoformat

let g:vim_markdown_folding_disabled = 1

set guifont=Monospace\ 12
iab <expr> dts strftime("%F")

set wildchar=<Tab> wildmenu wildmode=full
set wildcharm=<C-Z>
nnoremap <F10> :b <C-Z>

vnoremap <leader>p "_dP

nmap <C-T> gt
nmap <F3> vi[:sort<CR>

command! -nargs=1 Search call setqflist([]) | silent bufdo grepadd! <args> %

nnoremap <A-left>  :cprev<cr>zvzz
nnoremap <A-right> :cnext<cr>zvzz
