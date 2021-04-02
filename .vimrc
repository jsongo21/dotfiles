syntax on
set relativenumber
set nu
set showcmd
set laststatus=2
set hidden
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
set nohlsearch
set showmatch
set hlsearch
set termguicolors
set t_Co=16
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
call plug#end()

colorscheme monokai
