call plug#begin('~/.vim/plugged')

Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-sensible'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" (Optional) Multi-entry selection UI.
Plug 'junegunn/fzf'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-github-dashboard'
Plug 'terryma/vim-multiple-cursors'
Plug 'sjl/gundo.vim'
Plug 'tpope/vim-fugitive'
Plug 'plasticboy/vim-markdown'
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'LnL7/vim-nix'
Plug 'luochen1990/rainbow'
Plug 'scrooloose/nerdcommenter'
Plug 'dbeniamine/todo.txt-vim'
Plug 'racer-rust/vim-racer', { 'for': 'rust' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'daveyarwood/vim-alda'
Plug 'dylanaraps/wal.vim'
Plug 'altercation/vim-colors-solarized'
Plug 'ledger/vim-ledger'
Plug '~/.nix-profile/share/vim-plugins/fzf-vim'

call plug#end()

" colorscheme wal
set background=dark
colorscheme solarized

let g:LanguageClient_serverCommands = {
      \ 'nix': ['nix-lsp'],
      \ 'python': ['pyls'],
      \ }
let g:LanguageClient_loadSettings = 1
nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> gh :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> gr :call LanguageClient_textDocument_references()<CR>
nnoremap <silent> gs :call LanguageClient_textDocument_documentSymbol()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
nnoremap <silent> gf :call LanguageClient_textDocument_formatting()<CR>

let g:rainbow_active = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

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

" Commands reagarding vimrc
" When .vimrc is edited, automatically reload it
autocmd! bufwritepost .vimrc source ~/.vimrc

set tabstop=4
set expandtab
set shiftwidth=2
set softtabstop=2
" for Makefiles
" added some special formatting in Makefiles
autocmd BufEnter ?akefile* set noet ts=8 sw=8 nocindent list lcs=tab:>-,trail:x

filetype plugin indent on

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

let g:formatdef_rustfmt = '"rustfmt"'
let g:formatters_rust = ['rustfmt']

nnoremap <F3> :Autoformat<CR>
"au BufWrite * :Autoformat

let $RUST_SRC_PATH="/home/addy/rust/src/"

let g:vim_markdown_folding_disabled = 1

set guifont=Monospace\ 12
iab <expr> dts strftime("%F")

set wildchar=<Tab> wildmenu wildmode=full
set wildcharm=<C-Z>
nnoremap <F10> :b <C-Z>

vnoremap <leader>p "_dP
