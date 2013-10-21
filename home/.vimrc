call pathogen#infect()
filetype plugin indent on

syn on
set number
highlight LineNr cterm=none ctermfg=grey ctermbg=black

set hlsearch
nohl

" Indentation settings.  Automatic when relevant and 4 spaces.
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab

set noswapfile

set encoding=utf-8
set scrolloff=3
set visualbell
set ttyfast
set ignorecase
set smartcase
set incsearch
set showmatch
set showcmd

nnoremap j gj
nnoremap k gk

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

set cursorline
hi CursorLine ctermbg=234 cterm=none

let mapleader = ","

" CtrlP Stuff
nnoremap <C-o> :CtrlP 
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPMixed'

" NERDTree Stuff
nnoremap <leader>n :NERDTree<cr>

nnoremap <leader>h :set hlsearch! hlsearch?<cr>
" Vim yank register to system clipboard
nnoremap <leader>j :call system("pbcopy", getreg(""))<cr>

set list       
set listchars=tab:▸\  ", "eol:¬
 
hi MatchParen cterm=underline ctermbg=none
hi NonText ctermfg=4
hi VertSplit term=bold,reverse cterm=reverse gui=bold,reverse ctermfg=0 ctermbg=4

hi Comment      ctermfg=7 cterm=none
hi Todo         ctermfg=0 ctermbg=3 cterm=none
hi Constant     ctermfg=1 cterm=none
hi String       ctermfg=4* cterm=none
hi Identifier   ctermfg=4 cterm=none
hi Function     ctermfg=2 cterm=none
hi Type         ctermfg=5 cterm=none
hi Statement    ctermfg=3 cterm=none
hi Keyword      ctermfg=3 cterm=none
hi PreProc      ctermfg=3 cterm=none
hi Number       ctermfg=1* cterm=none
hi Special      ctermfg=5 cterm=none

set term=xterm-256color
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_min_count = 2
"let g:airline#extensions#tabline#tab_min_count = 2

set laststatus=2   " Always show the statusline
