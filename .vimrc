"set rtp+=/usr/lib/python3.5/site-packages/powerline/bindings/vim
"set laststatus=2
"set t_Co=256
execute pathogen#infect()
syntax on
filetype plugin indent on

set number "Show line number
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

let g:ycm_global_ycm_extra_conf = '/home/maruli/.vim/autoload/.ycm_extra_conf.py'
let g:ycm_rust_src_path = '/media/dua/github/rust/src'
"let g:powerline_pycmd py3
let $PYTHONPATH='/usr/lib/python3.5/site-packages'
set laststatus=2
