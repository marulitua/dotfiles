" Build markdown preview server
function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release
    else
      !cargo build --release --no-default-features --features json-rpc
    endif
  endif
endfunction

" START PLUG
call plug#begin('~/.local/share/nvim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'scrooloose/nerdtree'
Plug 'dockyard/vim-easydir'
Plug 'junegunn/fzf', { 'dir': '~/.fzf/', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-sleuth'
Plug 'Yggdroot/indentLine'
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
Plug 'majutsushi/tagbar'
Plug 'w0rp/ale'

" Code completion
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" javascript
Plug 'mhartington/nvim-typescript'
Plug 'pangloss/vim-javascript'

" rust language
Plug 'rust-lang/rust.vim'
Plug 'sebastianmarkow/deoplete-rust'

" END PLUG
call plug#end()

"" Show line numbers.
set number
set relativenumber

"" Automatic indentation.
"filetype indent on

let g:indentLine_setColors = 0
let g:indentLine_color_term = 8
let g:indentLine_char = '┊'

"" Visual settings
if has('nvim')
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

"set colorcolumn=80
call matchadd('ColorColumn', '\%81v', 100) "Give warning when line  > 80

"  UTF-8 FTW
set encoding=utf-8

" enable syntax highlight 
syntax on

"" Clipboard
set clipboard=unnamedplus

exec "set list listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~,eol:¬"
set list

" Highlight match word
nnoremap <silent> n   n:call HLNext(0.4)<cr>
nnoremap <silent> N   N:call HLNext(0.4)<cr>

highlight WhiteOnRed ctermbg=red guibg=darkred

" OR ELSE just highlight the match in red..."
function! HLNext (blinktime)
  let [bufnum, lnum, col, off] = getpos('.')
  let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
  let target_pat = '\c\%#\%('.@/.'\)'
  let ring = matchadd('WhiteOnRed', target_pat, 101)
  redraw
  exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
  call matchdelete(ring)
  redraw
endfunction

"" Nerd tree
let g:nerdtree_tabs_open_on_console_startup=0
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
""" Key: CTRL+n         | Toggle tree
map <C-n> :NERDTreeToggle<CR>

" Fuzzy file finder
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-v': 'vsplit'
      \ }
nnoremap <c-p> :FZF<cr>

let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10split enew' }

command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
      \   <bang>0 ? fzf#vim#with_preview('up:60%')
      \           : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0)

command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

" Markdown automatic HTML preview
" let g:markdown_composer_syntax_theme='hybrid'

command! -bang -nargs=* Find
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(expand('<cword>')), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

"" Tagbar
autocmd FileType * nested :call tagbar#autoopen()
""" key: $mod+F8        | Action: Toggle tagbar
nmap <F8> :TagbarToggle<CR>
let g:tagbar_autofocus = 0
let g:tagbar_compact = 1

" Vue
let g:vue_disable_pre_processors=1

" write to the same file
set backupcopy=yes

" Start deoplete completion engine
let g:deoplete#enable_at_startup = 1

" set rust source code path
"let g:deoplete#sources#rust#rust_source_path='/media/uno/repos/rust/src'
let g:deoplete#sources#rust#rust_source_path=$RUST_SOURCE_PATH

"let g:deoplete#sources#rust#racer_binary='/home/maruli/.cargo/bin/racer'
let g:deoplete#sources#rust#racer_binary=$RACER_BIN_PATH

" show duplicate matches
let g:deoplete#sources#rust#show_duplicates=1

"" close preview window on leaving the insert mode
autocmd InsertLeave * if pumvisible() == 0 | pclose | AirlineRefresh | endif

" Set language server
set hidden
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['javascript-typescript-stdio'],
    \ 'php': ['/usr/bin/php', $PHP_LS_PATH],
    \ 'vue': ['vls'],
    \ }

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
