call pathogen#infect()
filetype plugin indent on


syn on
set number
highlight LineNr cterm=none ctermfg=grey

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
" set cursorline
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

hi CursorLine   cterm=underline ctermbg=none ctermfg=none guibg=none guifg=none
hi CursorColumn   cterm=underline ctermbg=none ctermfg=none guibg=none guifg=none


let mapleader = ","

nnoremap <C-o> :CtrlP 
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPMixed'
nnoremap <leader>n :NERDTree<cr>
nnoremap <leader>h :set hlsearch! hlsearch?<cr>

" Copy from visual mode
vnoremap <leader>y y:w !pbcopy<cr><cr>
" Vim yank register to system clipboard
nnoremap <leader>j :call system("pbcopy", getreg(""))<cr>


" set list       
" set listchars=tab:▸\ ,eol:¬

 
hi MatchParen cterm=underline ctermbg=none
hi NonText ctermfg=4
hi VertSplit term=bold,reverse cterm=reverse gui=bold,reverse ctermfg=0 ctermbg=4
hi StatusLineNC term=underline,reverse cterm=underline,reverse gui=reverse ctermfg=0 ctermbg=4
hi StatusLine term=none cterm=underline gui=none ctermfg=0 ctermbg=4

hi User1 ctermbg=4 ctermfg=0 guibg=green guifg=red cterm=underline

hi User2 ctermbg=3 ctermfg=0 guibg=none guifg=none cterm=underline
hi User3 ctermbg=green ctermfg=red guibg=green guifg=red

" set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P
"set statusline=%1*
set statusline=%F\       "Full path
" set statusline+=%t       "tail of the filename
set statusline+=%*[%n%H%M%R%W]
"set statusline+=%h      "help file flag
"set statusline+=\ %m      "modified flag
"set statusline+=%r      "read only flag

"set statusline+=%y       "filetype
set statusline+=%=      "left/right separator

set statusline+=%L\     "Total line count
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=\ %P    "percent through file
set laststatus=2

"if version >= 700
"  au InsertEnter * hi StatusLine term=reverse ctermbg=5 gui=undercurl guisp=Magenta
"  au InsertLeave * hi StatusLine term=reverse ctermfg=0 ctermbg=2 gui=bold,reverse
"endif

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
