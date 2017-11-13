function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release
    else
      !cargo build --release --no-default-features --features json-rpc
    endif
  endif
endfunction
call plug#begin('~/.local/share/nvim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'c9s/phpunit.vim'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'easymotion/vim-easymotion'
Plug 'StanAngeloff/php.vim'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'tpope/vim-sleuth'
Plug 'joonty/vdebug'
Plug 'janko-m/vim-test'
Plug 'tpope/vim-cucumber'
Plug 'vim-airline/vim-airline'
Plug 'majutsushi/tagbar'
" PHP support NVIM
Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/echodoc.vim'
Plug 'roxma/LanguageServer-php-neovim', {'do': 'composer install && composer run-script parse-stubs'}

Plug 'rust-lang/rust.vim'
Plug 'sebastianmarkow/deoplete-rust'
Plug 'dracula/vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf/', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'dockyard/vim-easydir'
Plug 'sheerun/vim-polyglot'
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
Plug 'jremmen/vim-ripgrep'
call plug#end()

"" Maps additional php extensions
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
if has("autocmd")
  augroup module
    autocmd BufRead,BufNewFile *.module set filetype=php
    autocmd BufRead,BufNewFile *.install set filetype=php
    autocmd BufRead,BufNewFile *.test set filetype=php
    autocmd BufRead,BufNewFile *.inc set filetype=php
    autocmd BufRead,BufNewFile *.profile set filetype=php
    autocmd BufRead,BufNewFile *.view set filetype=php
  augroup END
endif

"" Show line numbers.
set number
set relativenumber

"" Automatic indentation.
filetype indent on

"" Reloads the vim config after saving.
augroup myvimrc
        au!
        au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"" Nerd tree
let g:nerdtree_tabs_open_on_console_startup=0
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
""" Key: CTRL+n         | Toggle tree
map <C-n> :NERDTreeToggle<CR>

"" TestSuite
" Runner
let test#strategy = "neovim"
let test#php#cucumber#executable = 'tests/behat -c tests/behat.yml'
let test#ruby#cucumber#executable = 'tests/behat -c tests/behat.yml'
let test#php#phpunit#executable = 'vendor/bin/phpunit'
""" Key: $mod+t         | Test nearest
""" Key: $mod+T         | Test File
""" Key: $mod+a         | Test suite
""" Key: $mod+l         | Test Test last
""" Key: $mod+g         | Test Visit
nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>
" Maps .feature extension to cucumber
augroup filetypedetect
        au! BufReadPre,BufReadPost,BufRead,BufNewFile *.feature setfiletype cucumber
augroup END

"" Tagbar
autocmd FileType * nested :call tagbar#autoopen()
""" key: $mod+F8        | Action: Toggle tagbar
nmap <leader><F8> :TagbarToggle<CR>
let g:tagbar_autofocus = 0
let g:tagbar_compact = 1

"" Php autocomplete
" Disable diagnostics
let g:LanguageClient_diagnosticsDisplay = {}
" Deoplete config
"let g:deoplete#auto_complete_start_length=1
"let g:deoplete#omni_patterns = {}
" Required for operations modifying multiple buffers like rename.
set hidden
let g:LanguageClient_serverCommands = {
    \ 'php': ['/usr/bin/php', '/home/maruli/.composer/vendor/bin/php-language-server.php'],
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ }
let g:deoplete#enable_at_startup = 1
""" Key: K                | Action: Hover
""" Key: gd               | Action: go to definition
""" Key: f2               | Action: Rename
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>

"" Git gutter.
"let g:gitgutter_sign_column_always = 1
set signcolumn=yes

"" Visual settings
if has('nvim')
    "let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif
set encoding=utf-8
"set colorcolumn=80
call matchadd('ColorColumn', '\%81v', 100) "Give warning when line  > 80
syntax on

"" Clipboard
set clipboard=unnamedplus

"" Vdebug
let g:vdebug_options= {
  \    "port" : 9000,
  \    "server" : '',
  \    "timeout" : 20,
  \    "on_close" : 'detach',
  \    "break_on_open" : 0,
  \    "ide_key" : '',
  \    "path_maps" : {},
  \    "debug_window_level" : 0,
  \    "debug_file_level" : 0,
  \    "debug_file" : "",
  \    "watch_window_style" : 'compact',
  \    "marker_default" : '⬦',
  \    "marker_closed_tree" : '▸',
  \    "marker_open_tree" : '▾'
  \ }

exec "set list listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~,eol:¬"
set list

autocmd FileType php LanguageClientStart
let g:LanguageServer_autoStart = 1

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

" set auto completion rust
let g:deoplete#sources#rust#racer_binary='/home/maruli/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path='/home/maruli/rust/src'

let g:deoplete#sources#rust#show_duplicates=1

color dracula

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

" Markdown automatic HTML preview
" let g:markdown_composer_syntax_theme='hybrid'
