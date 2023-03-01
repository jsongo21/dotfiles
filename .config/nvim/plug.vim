
call plug#begin('~/.vim/plugged')
Plug 'gko/vim-coloresque'
Plug 'gruvbox-community/gruvbox'
Plug 'dracula/vim', { 'as': 'dracula'  }
Plug 'tjdevries/colorbuddy.vim'
Plug 'bkegley/gloombuddy'
Plug 'rrethy/nvim-base16'
Plug 'vim-scripts/vim-gitgutter'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-tsserver'
Plug 'neoclide/coc-prettier'
Plug 'neoclide/coc-eslint'
Plug 'neoclide/coc-tslint'
Plug 'neoclide/coc-jest'
Plug 'neoclide/coc-json'
"Plug 'pangloss/vim-javascript'    " JavaScript support
"Plug 'leafgarland/typescript-vim' " TypeScript syntax
"Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
"Plug 'jparise/vim-graphql'        " GraphQL syntax
"Plug 'herringtondarkholme/yats.vim' " Typescript Syntax
Plug 'jiangmiao/auto-pairs'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'wakatime/vim-wakatime'

if has('nvim')
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'neovim/nvim-lspconfig'
    Plug 'kyazdani42/nvim-web-devicons' " for file icons
    Plug 'kyazdani42/nvim-tree.lua'
endif

call plug#end()
