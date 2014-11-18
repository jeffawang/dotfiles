call pathogen#infect()
filetype plugin indent on

syn on
set number

set hlsearch
nohl

" Indentation settings.  Automatic when relevant and 4 spaces.
set smartindent
set tabstop=4
set shiftwidth=4
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
let g:ctrlp_working_path_mode = 1

" NERDTree Stuff
nnoremap <leader>n :NERDTree<cr>
let NERDTreeChDirMode=2

nnoremap <leader>h :nohl<cr>
" Vim yank register to system clipboard
nnoremap <leader>j :call system("pbcopy", getreg(""))<cr>

" Tab and Buffer Navigation
"nnoremap <tab> :tabn<cr>
"nnoremap <S-tab> :tabp<cr>
nnoremap <leader><space> :bn<cr>
nnoremap <leader><S-space> :bp<cr>
nnoremap <leader>b :bn<cr>
nnoremap <leader>v :bp<cr>

nnoremap <leader>w :w<cr>
nnoremap <leader>q :bp\|bd#<cr>
nnoremap <leader>Q :bp!\|bd!#<cr>
nnoremap <leader>x :w\|bd<cr>


set list
set listchars=tab:▸\  ", "eol:¬

hi MatchParen cterm=underline ctermbg=none
hi NonText ctermfg=4
hi VertSplit term=bold,reverse cterm=reverse gui=bold,reverse ctermfg=0 ctermbg=4

set t_Co=256



" Hi hi xD
hi Comment      ctermfg=08 cterm=none
hi Todo         ctermfg=0 ctermbg=3 cterm=none
hi Constant     ctermfg=04 cterm=none
hi String       ctermfg=4* cterm=none
hi Identifier   ctermfg=4 cterm=none
"hi Function     ctermfg=71 cterm=none
hi Function     ctermfg=04 cterm=none
hi Type         ctermfg=03 cterm=none
hi Statement    ctermfg=71 cterm=none
hi PreProc      ctermfg=71 cterm=none
hi Keyword      ctermfg=3 cterm=none
hi Number       ctermfg=04 cterm=none
hi Special      ctermfg=5 cterm=none
hi Search       ctermfg=0 ctermbg=1     cterm=none
hi LineNr       ctermfg=239 ctermbg=233 cterm=none
hi Folded       ctermfg=4 ctermbg=none cterm=underline

hi todoIncomplete ctermfg=3
hi todoInProgress ctermfg=4
hi todoComplete ctermfg=2
hi todoComment ctermfg=8
hi todoPending ctermfg=1
hi todoHash ctermfg=5

set foldmethod=indent
set nofoldenable

let g:airline_theme='omg'
set term=xterm-256color
let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_min_count = 1
let g:airline#extensions#tabline#tab_min_count = 1

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline#extensions#tabline#tab_nr_type = 1

set laststatus=2   " Always show the statusline
set showtabline=2

" let g:airline_section_z = '%{hostname()}'

let g:airline#extensions#branch#enabled = 1

" Snippet stuff
