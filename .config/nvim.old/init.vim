set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath

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
set re=0
set mouse=a
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
runtime ./plug.vim
""""""""

"""""""" Colorschemes
"set bg=dark
colorscheme gruvbox
"let g:dracula_colorterm=0
"colorscheme dracula
"colorscheme gloombuddy
"colorscheme base16-gruvbox-dark-soft
""""""""

"""""""" Key Bindings
runtime ./maps.vim
""""""""

"""""""" Functions
" Trim WhiteSpace on Save
fun! TrimWhiteSpace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

function! ShowDocIfNoDiagnostic(timer_id)
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    endif
endfunction

function! s:show_hover_doc()
    call timer_start(50, 'ShowDocIfNoDiagnostic')
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

"augroup NERD
"    au!
"    autocmd VimEnter * NERDTree
"    autocmd VimEnter * wincmd p
"augroup END
""""""""

"""""""" Extensions
let g:coc_global_extensions = ['coc-tsserver', 'coc-json']
let g:indent_guides_enable_on_vim_startup = 1
let g:airline_theme='base16_gruvbox_dark_hard'
let g:airline_powerline_fonts=1
