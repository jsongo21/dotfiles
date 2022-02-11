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
"Plug 'pangloss/vim-javascript'    " JavaScript support
"Plug 'leafgarland/typescript-vim' " TypeScript syntax
"Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
"Plug 'jparise/vim-graphql'        " GraphQL syntax
"Plug 'herringtondarkholme/yats.vim' " Typescript Syntax
Plug 'jiangmiao/auto-pairs'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
if has('nvim')
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'neovim/nvim-lspconfig'
    Plug 'kyazdani42/nvim-web-devicons' " for file icons
    Plug 'kyazdani42/nvim-tree.lua'
endif
call plug#end()
""""""""

"""""""" Colorschemes
"set bg=dark
"colorscheme gruvbox
"let g:dracula_colorterm=0
"colorscheme dracula
"colorscheme gloombuddy
colorscheme base16-gruvbox-dark-soft
let g:airline_theme='base16_gruvbox_dark_hard'
""""""""

"""""""" Key Bindings
let mapleader = " "

map <ScrollWheelDown> j
map <ScrollWheelUp> k

" Remap keys for applying codeAction to the current line.
nmap <leader>do <Plug>(coc-codeaction)

" Apply AutoFix to problem on the current line.
nmap <leader>fq <Plug>(coc-fix-current)

" Rename symbol
nmap <leader>rn <Plug>(coc-rename)

" NERDTree Bindings
"nnoremap <leader>n :NERDTreeFocus<CR>
"nnoremap <C-n> :NERDTree<CR>
"nnoremap <C-t> :NERDTreeToggle<CR>
"nnoremap <C-f> :NERDTreeFind<CR>

" nvim tree
nnoremap <leader>n :NvimTreeFocus<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <C-f> :NvimTreeFindFile<CR>


"CoC
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

"augroup NERD
"    au!
"    autocmd VimEnter * NERDTree
"    autocmd VimEnter * wincmd p
"augroup END
""""""""

"""""""" Extensions
let g:coc_global_extensions = ['coc-tsserver', 'coc-json']
let g:indent_guides_enable_on_vim_startup = 1
let NERDTreeShowHidden=1

" nvim tree
let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
let g:nvim_tree_highlight_opened_files = 1 "0 by default, will enable folder and file icon highlight for opened files/directories.
let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
let g:nvim_tree_add_trailing = 1 "0 by default, append a trailing slash to folder names
let g:nvim_tree_group_empty = 1 " 0 by default, compact folders that only contain a single folder into one node in the file tree
let g:nvim_tree_disable_window_picker = 1 "0 by default, will disable the window picker.
let g:nvim_tree_icon_padding = ' ' "one space by default, used for rendering the space between the icon and the filename. Use with caution, it could break rendering if you set an empty string depending on your font.
let g:nvim_tree_symlink_arrow = ' >> ' " defaults to ' ➛ '. used as a separator between symlinks' source and target.
let g:nvim_tree_respect_buf_cwd = 1 "0 by default, will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
let g:nvim_tree_create_in_closed_folder = 0 "1 by default, When creating files, sets the path of a file when cursor is on a closed folder to the parent folder when 0, and inside the folder when 1.
let g:nvim_tree_window_picker_exclude = {
    \   'filetype': [
    \     'notify',
    \     'packer',
    \     'qf'
    \   ],
    \   'buftype': [
    \     'terminal'
    \   ]
    \ }
" Dictionary of buffer option names mapped to a list of option values that
" indicates to the window picker that the buffer's window should not be
" selectable.
let g:nvim_tree_special_files = { 'README.md': 1, 'Makefile': 1, 'MAKEFILE': 1 } " List of filenames that gets highlighted with NvimTreeSpecialFile
let g:nvim_tree_show_icons = {
    \ 'git': 1,
    \ 'folders': 0,
    \ 'files': 0,
    \ 'folder_arrows': 0,
    \ }
"If 0, do not show the icons for one of 'git' 'folder' and 'files'
"1 by default, notice that if 'files' is 1, it will only display
"if nvim-web-devicons is installed and on your runtimepath.
"if folder is 1, you can also tell folder_arrows 1 to show small arrows next to the folder icons.
"but this will not work when you set indent_markers (because of UI conflict)

" default will show icon by default if no icon is provided
" default shows no icon by default
let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✓",
    \   'unmerged': "",
    \   'renamed': "➜",
    \   'untracked': "★",
    \   'deleted': "",
    \   'ignored': "◌"
    \   },
    \ 'folder': {
    \   'arrow_open': "",
    \   'arrow_closed': "",
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   }
    \ }

lua<<EOF

require'nvim-tree'.setup {
  disable_netrw        = true,
  hijack_netrw         = true,
  open_on_setup        = true,
  ignore_ft_on_setup   = {},
  auto_close           = false,
  auto_reload_on_write = true,
  open_on_tab          = false,
  hijack_cursor        = false,
  update_cwd           = false,
  update_to_buf_dir    = {
    enable = true,
    auto_open = true,
  },
  diagnostics = {
    enable = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  update_focused_file = {
    enable      = false,
    update_cwd  = false,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  filters = {
    dotfiles = false,
    custom = {}
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  view = {
    width = 30,
    height = 30,
    hide_root_folder = false,
    side = 'left',
    auto_resize = true,
    mappings = {
      custom_only = false,
      list = {}
    },
    number = false,
    relativenumber = false,
    signcolumn = "yes"
  },
  trash = {
    cmd = "trash",
    require_confirm = true
  },
  actions = {
    change_dir = {
      global = false,
    },
    open_file = {
      quit_on_open = false,
    }
  }
}

EOF
""""""""

"""""""" Tree Sitter
lua << EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {}
  },
  indent = {
      enable = true
  },
  ensure_installed = {
    "typescript",
    "javascript",
    "tsx",
    "json",
    "html",
    "css",
    "scss"
  },
}
EOF
