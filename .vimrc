"UI config
set number
set relativenumber
set showcmd
set laststatus=2
set encoding=utf8
set autoindent
set smartindent
set smartcase
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

"swap
set noswapfile
set nobackup

" syntax and colours
syntax on 
au InsertEnter * hi StatusLine guibg=Red
au InsertLeave * hi StatusLine guibg=#ccdc90

" vim-plug auto install
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.vimrc
endif

" plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" declare the list of plugins.
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'morhetz/gruvbox'

" list ends here. Plugins become visible to Vim after this call.
call plug#end()

" themes
let base16colorspace=256
set background=dark
colorscheme gruvbox

