" Use <leader>f to toggle NERDTree
autocmd VimEnter * nnoremap <silent> <leader>f :if exists('b:NERDTree') <BAR>
            \ NERDTreeToggle <BAR> else <BAR> NERDTreeCWD <BAR> endif <CR>
" Use <leader><TAB> to focus on current file in NERDTree
autocmd VimEnter * nnoremap <silent> <leader><TAB> :NERDTreeFind<CR>

" Close vim if the only window left is a NERDTree
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") &&
            \ b:NERDTree.isTabTree()) | q | endif

" Show hidden files
let g:NERDTreeShowHidden = 1
" Ignored
let g:NERDTreeIgnore = ['.git']

" Author: Blurgy
" Date:   Jul 29 2020
