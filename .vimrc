syntax enable
set relativenumber
set nu
set showcmd
set signcolumn=yes
set laststatus=2
set hidden
set cmdheight=2

set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set ignorecase

set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set showmatch
set noshowmode
set nohlsearch
set scrolloff=8
set completeopt=menuone,noinsert,noselect


"Insert Mode Cursor & Delay
let &t_SI = "\<esc>[5 q"
let &t_SR = "\<esc>[5 q"
let &t_EI = "\<esc>[2 q"
set ttimeout
set ttimeoutlen=1
set listchars=tab:>-,trail:~,extends:>,precedes:<,space:.
set ttyfast

"Vim-Plug
call plug#begin('~/.vim/plugged')
Plug 'dracula/vim',{'as':'dracula'}
Plug 'lsdr/monokai'
Plug 'gko/vim-coloresque'
Plug 'gilgigilgil/anderson.vim'
Plug 'gruvbox-community/gruvbox'
Plug 'vim-scripts/vim-gitgutter'
call plug#end()

"Colorschemes
"let g:dracula_colorterm=0
"colorscheme dracula
colorscheme gruvbox
set bg=dark

"key bindings


"Trim WhiteSpace on Save
fun! TrimWhiteSpace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup THE_PRIMEAGEN
    autocmd!
    autocmd BufWritePre * :call TrimWhiteSpace()
augroup END
