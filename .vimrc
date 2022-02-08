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
set nowrap
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
set termguicolors

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
Plug 'gko/vim-coloresque'
Plug 'gruvbox-community/gruvbox'
Plug 'vim-scripts/vim-gitgutter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

"Colorschemes
colorscheme gruvbox
set bg=dark

"key bindings
let mapleader = " "

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
