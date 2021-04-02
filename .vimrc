syntax on
set relativenumber
set nu
set nohlsearch
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
set termguicolors
set t_Co=16
set scrolloff=8
set completeopt=menuone,noinsert,noselect


"Vim-Plug
call plug#begin('~/.vim/plugged')
Plug 'dracula/vim',{'as':'dracula'}
Plug 'lsdr/monokai'
call plug#end()

colorscheme monokai
