" NERDtree
map <Leader>e :NERDTreeToggle<CR>
map <Leader>f :NERDTreeFind<CR>
let NERDTreeQuitOnOpen=1
let NERDTreeWinSize=35
let NERDTreeCaseSensitiveSort=1
" let NERDTreeWinPos = "right"

let NERDTreeIgnore=['\~$', '\.pyc$', '^\.DS_Store$', '^node_modules$', '.git$', '.ropeproject', '__pycache__']

" autocmd VimEnter * NERDTree | wincmd p

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
