let mapleader = " "

map <ScrollWheelDown> j
map <ScrollWheelUp> k

" source vimrc
nnoremap <Leader>sv :source $MYVIMRC<CR>

" Remap keys for applying codeAction to the current line.
nmap <leader>do <Plug>(coc-codeaction)

" Apply AutoFix to problem on the current line.
nmap <leader>fq <Plug>(coc-fix-current)

" Rename symbol
nmap <leader>rn <Plug>(coc-rename)

" nvim tree
nnoremap <leader>t :NvimTreeToggle<CR>
nnoremap <leader>n :NvimTreeFocus<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <C-f> :NvimTreeFindFile<CR>

" Fzf
nnoremap <leader>f :GFiles<CR>

"CoC
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> <space>d :<C-u>CocList diagnostics<cr>

"CoC Autocomplete
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Fugitive
nmap <leader>gs :Git<CR>
nmap <leader>gj :diffget //3<CR>
nmap <leader>gf :diffget //2<CR>
