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

"let g:python_host_prog  = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'
"let g:loaded_python_provider = 1
"let g:vimtex_compiler_progname = 'nvr'
let g:loaded_python_provider = 0
"let g:loaded_node_provider=1

" START PLUG
call plug#begin('~/.local/share/nvim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-vetur', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-yaml', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-snippets', {'do': 'yarn install --frozen-lockfile'}
Plug 'fannheyward/coc-rust-analyzer', {'do': 'yarn install --frozen-lockfile'}
Plug 'iamcco/coc-actions', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-html', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-highlight', {'do': 'yarn install --frozen-lockfile'}
Plug 'iamcco/coc-flutter'
Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
Plug 'fannheyward/coc-sql'
Plug 'coc-extensions/coc-svelte'
Plug 'clangd/coc-clangd'
Plug 'honza/vim-snippets'
Plug 'junegunn/fzf', { 'dir': '~/.fzf/', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
Plug 'lervag/vimtex'
Plug 'sheerun/vim-polyglot'
Plug 'psliwka/vim-smoothie'
Plug 'dockyard/vim-easydir'
Plug 'tpope/vim-sleuth'
Plug 'Yggdroot/indentLine'
Plug 'metakirby5/codi.vim'
Plug 'w0rp/ale'
Plug 'embear/vim-localvimrc'
Plug 'dart-lang/dart-vim-plugin'
Plug 'morhetz/gruvbox'
Plug 'editorconfig/editorconfig-vim'
Plug 'liuchengxu/vista.vim'
Plug 'jackguo380/vim-lsp-cxx-highlight'

" END PLUG
call plug#end()

source $HOME/.config/nvim/coc.vim

" To get correct comment highlighting
autocmd FileType json syntax match Comment +\/\/.\+$+

" Show line numbers.
set number
set relativenumber

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

command! -bang -nargs=* Find call fzf#vim#grep('ag --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

" Markdown automatic HTML preview
let g:markdown_composer_syntax_theme='hybrid'

command! -bang -nargs=* Find
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(expand('<cword>')), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

"" Nerd tree
"let g:nerdtree_tabs_open_on_console_startup=0
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
""" Key: CTRL+n         | Toggle tree
map <C-n> :NERDTreeToggle<CR>

"" Visual settings
if has('nvim')
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

"  UTF-8 FTW
set encoding=utf-8

" To enable highlight current symbol on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" enable syntax highlight
syntax on

" write to the same file
set backupcopy=yes

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

"" Vista
nmap <F8> :Vista!!<CR>
nmap <F7> :Vista finder<CR>
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_fzf_preview = ['right:30%']
let g:vista#renderer#enable_icon = 1
let g:vista_sidebar_width = 30
let g:vista_default_executive = 'coc'
let g:vista_disable_statusline = 0

function NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

set statusline+=%{NearestMethodOrFunction()}

autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

" ALE
let g:airline#extensions#ale#enabled = 1
"let g:neosnippet#enable_snipmate_compatibility = 1
"let g:neosnippet#snippets_directory='~/.config/nvim/plugged/vim-snippets/snippets'

" Vim-localvimrc
let g:localvimrc_enable = 0

" Disabling lvimrc sandboxing
let g:localvimrc_sandbox = 0

" coc-snippets
" Use <C-l> for tigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" c++ syntax highlighting
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
inoremap <silent><expr> <C-x><C-z> coc#pum#visible() ? coc#pum#stop() : "\<C-x>\<C-z>"
" remap for complete to use tab and <cr>
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <c-space> coc#refresh()

hi CocSearch ctermfg=12 guifg=#18A3FF
hi CocMenuSel ctermbg=109 guibg=#13354A

function s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~ '\s'
endfunction

let g:coc_snippet_next='<tab>'

" Remap for do codeAction of selected region
function! s:cocActionOpenFromSelected(type) abort
  execute 'CocCommand actions.open'.a:type
endfunction
xmap <silent> <leader>a:<C-u>execute 'CocCommand actions.open'.visualmode()<CR>
nmap <silent> <leader>a:<C-u>set operatorfunc=<SID>cocActionOpenFromSelected<CR>g@

set termguicolors
colorscheme gruvbox
"hi Quote ctermbg=109 guifg=#83a598
"set colorcolumn=81
call matchadd('ColorColumn', '\%81v', 100) "Give warning when line  > 80
autocmd FileWritePost * call matchadd('ColorColumn', '\%81v', 100) "Give warning when line  > 80
autocmd BufReadPost * call matchadd('ColorColumn', '\%81v', 100) "Give warning when line  > 80
highlight ColorColumn ctermbg=135 guibg=#850127
