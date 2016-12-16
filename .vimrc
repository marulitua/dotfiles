"set rtp+=/usr/lib/python3.5/site-packages/powerline/bindings/vim
"set laststatus=2
"set t_Co=256
execute pathogen#infect()
syntax on
filetype plugin indent on

set rnu "Show relative line number
set nu "Show absolute line number
"autocmd vimenter * NERDTree "Run NERDTree
map <C-n> :NERDTreeToggle<CR>

call matchadd('ColorColumn', '\%81v', 100) "Give warning when line  > 80

exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~,eol:¬"
set list

set expandtab
set smarttab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent

"nnoremap ; : "swap ; :
"nnoremap : ; "swap ; :

let g:ycm_global_ycm_extra_conf = '/home/maruli/.vim/autoload/.ycm_extra_conf.py'
let g:ycm_rust_src_path = '/media/dua/github/rust/src'
"let g:powerline_pycmd py3
let $PYTHONPATH='/usr/lib/python3.5/site-packages'
set laststatus=2
set runtimepath^=~/.vim/bundle/ctrlp.vim

if executable('ag')
	" use Ag iser Grep
	set grepprg=ag\ --nogroup\ --nocolor

	" use ag in CtrlP for listing files. Lightning fast and respets .gitignore
	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

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
let g:airline_powerline_fonts = 1

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use age in CtrlP for listing files. Lightning fast and respect .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor --silent -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_user_caching = 0
endif

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" bind \ (backward slash) to grep shortcut
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

" bind \ to :Ag<SPACE>
nnoremap \ :Ag<SPACE>

if executable('matcher')
  let g:ctrlp_match_func = { 'match': 'GoodMatch' }

  function! GoodMatch(items, str, limit, mmode, ispath, crfile, regex)
    " Create a cache file if not yet exists
    let cachefile = ctrlp#utils#cachedir().'/matcher.cache'
    if !( filereadable(cachefile) && a:items == readfile(cachefile) )
      call writefile(a:items, cachefile)
    endif
    if !filereadable(cachefile)
      return []
    endif

    " a:mmode is currently ignored. In the future, we should probably do
    " something about that. The matcher behaves like "full-line".
    let cmd = 'matcher --limit '.a:limit.' --manifest '.cachefile.' '
    if !( exists('g:ctrlp_dotfiles') && g:ctrlp_dotfiles )
      let cmd = cmd.'--no-dotfiles '
    endif
    let cmd = cmd.a:str

    return split(system(cmd), "\n")

  endfunction
end

"color contrastneed
