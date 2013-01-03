call pathogen#infect()
filetype plugin indent on

syn on
set number
highlight LineNr ctermfg=darkgrey

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
set cursorline
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


let mapleader = ","
nnoremap <leader><leader> :NERDTree<cr>

set list       
set listchars=tab:▸\ ,eol:¬
 
hi NonText ctermfg=4
hi VertSplit term=bold,reverse cterm=reverse gui=bold,reverse ctermfg=0 ctermbg=4
hi StatusLineNC term=underline,reverse cterm=underline,reverse gui=bold,reverse ctermfg=0 ctermbg=4
hi StatusLine term=bold cterm=bold gui=bold ctermfg=grey ctermbg=4
" set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P
set statusline=%F       "Full path
" set statusline+=%t       "tail of the filename
set statusline+=%h      "help file flag
set statusline+=\ %m      "modified flag
set statusline+=%r      "read only flag
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
hi Constant     ctermfg=5 cterm=none
hi String       ctermfg=1* cterm=none
hi Identifier   ctermfg=4 cterm=none
hi Function     ctermfg=2 cterm=none
hi Type         ctermfg=5 cterm=none
hi Statement    ctermfg=3 cterm=none
hi Keyword      ctermfg=3 cterm=none
hi PreProc      ctermfg=4 cterm=none
hi Number       ctermfg=1* cterm=none
hi Special      ctermfg=4 cterm=none
