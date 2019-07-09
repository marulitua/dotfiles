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

" vim-plug autoconfig if not already installed
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | nested source $MYVIMRC
endif

let g:python_host_prog  = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'
let g:loaded_python_provider = 1
let g:vimtex_compiler_progname = 'nvr'

" START PLUG
call plug#begin('~/.local/share/nvim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
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
Plug 'lervag/vimtex'
Plug 'w0rp/ale'
Plug 'posva/vim-vue'
Plug 'liuchengxu/vista.vim'

" Code completion
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" javascript
Plug 'HerringtonDarkholme/yats.vim'
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
Plug 'pangloss/vim-javascript'

" rust language
Plug 'rust-lang/rust.vim'
Plug 'sebastianmarkow/deoplete-rust'

" Snippets
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

" END PLUG
call plug#end()

"" Show line numbers.
set number
set relativenumber

set tabstop=4       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.

set shiftwidth=4    " Indents will have a width of 4

set softtabstop=4   " Sets the number of columns for a TAB

"set expandtab       " Expand TABs to spaces

"" Automatic indentation.
filetype indent on

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

set tabstop=4       " The width of a TAB is set to 4.
                    " Still it is a \t. It is just that
                    " Vim will interpret it to be having
                    " a width of 4.

set shiftwidth=4    " Indents will have a width of 4

set softtabstop=4   " Sets the number of columns for a TAB

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
"let g:nerdtree_tabs_open_on_console_startup=0
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
let g:markdown_composer_syntax_theme='hybrid'

command! -bang -nargs=* Find
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(expand('<cword>')), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

"" Tagbar
"autocmd FileType * nested :call tagbar#autoopen()
""" key: $mod+F8        | Action: Toggle tagbar
"nmap <F8> :TagbarToggle<CR>
"let g:tagbar_autofocus = 0
"let g:tagbar_compact = 1

"" Vista
nmap <F8> :Vista!!<CR>
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_default_executive = 'lcn'
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1
let g:vista_sidebar_width = 130

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

" ALE
let g:airline#extensions#ale#enabled = 1
"let g:neosnippet#enable_snipmate_compatibility = 1
"let g:neosnippet#snippets_directory='~/.config/nvim/plugged/vim-snippets/snippets'

" neovim-remote
"let g:vimtex_compiler_progname = 'nvr'
"let g:tex_flavor='latex'
"let g:vimtex_view_method='zathura'
"let g:vimtex_quickfix_mode=0
"set conceallevel=1
"let g:tex_conceal='abdmg'

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
    \ 'dockerfile': ['docker-langserver', '--stdio'],
    \ 'sh': ['bash-language-server', 'start'],
    \ }

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

" Remember folds
"autocmd BufWinLeave *.* mkview
"autocmd BufWinEnter *.* silent loadview
