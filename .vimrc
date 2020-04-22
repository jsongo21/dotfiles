"UI config
set number
set relativenumber
set showcmd
set laststatus=2
set encoding=utf8
set autoindent
set wildmenu            " visual autocomplete for command menu
set showmatch

"spaces & tab
set shiftwidth=2
set tabstop=2
set expandtab
set softtabstop=4

"searching
set incsearch
set hlsearch

"folding
set foldenable
set foldmethod=indent
set foldlevelstart=10
set foldnestmax=10

"colours & themes
syntax enable 
colorscheme monokai
au InsertEnter * hi StatusLine guibg=Red
au InsertLeave * hi StatusLine guibg=#ccdc90

"swap
set noswapfile
