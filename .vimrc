"""""""" Vim Set Options
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
set nohlsearch
set scrolloff=8
set completeopt=menuone,noinsert,noselect
set termguicolors
""""""""

"""""""" Insert Mode Cursor & Delay
let &t_SI = "\<esc>[5 q"
let &t_SR = "\<esc>[5 q"
let &t_EI = "\<esc>[2 q"
set ttimeout
set ttimeoutlen=1
set listchars=tab:>-,trail:~,extends:>,precedes:<,space:.
set ttyfast
""""""""

"""""""" Vim-Plug
call plug#begin('~/.vim/plugged')
Plug 'gko/vim-coloresque'
Plug 'gruvbox-community/gruvbox'
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
Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'leafgarland/typescript-vim' " TypeScript syntax
Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
Plug 'jparise/vim-graphql'        " GraphQL syntax
Plug 'jiangmiao/auto-pairs'
Plug 'nathanaelkane/vim-indent-guides'
call plug#end()
""""""""

"""""""" Colorschemes
colorscheme gruvbox
set bg=dark
""""""""

"""""""" Key Bindings
let mapleader = " "

" Remap keys for applying codeAction to the current line.
nmap <leader>do <Plug>(coc-codeaction)

" Apply AutoFix to problem on the current line.
nmap <leader>fq <Plug>(coc-fix-current)

" Rename symbol
nmap <leader>rn <Plug>(coc-rename)

" NERDTree Bindings
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" CoC
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>
""""""""

"""""""" Functions
" Trim WhiteSpace on Save
fun! TrimWhiteSpace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

function! ShowDocIfNoDiagnostic(timer_id)
    if (coc#float#has_float() == 0 && CocHasProvider('hover') == 1)
        silent call CocActionAsync('doHover')
    endif
endfunction

function! s:show_hover_doc()
    call timer_start(200, 'ShowDocIfNoDiagnostic')
endfunction
""""""""

"""""""" Auto Commands
augroup THE_PRIMEAGEN
    autocmd!
    autocmd BufWritePre * :call TrimWhiteSpace()
augroup END

autocmd CursorHoldI * :call <SID>show_hover_doc()
autocmd CursorHold * :call <SID>show_hover_doc()
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 softtabstop=0 expandtab
autocmd FileType typescript setlocal shiftwidth=2 tabstop=2 softtabstop=0 expandtab
autocmd VimEnter * NERDTree
""""""""

"""""""" Extensions
"let g:coc_global_extensions = ["coc-tsserver", "coc-json"]
let g:indent_guides_enable_on_vim_startup = 1
""""""""
