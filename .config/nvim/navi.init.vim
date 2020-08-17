" Use <leader>d to toggle coc-explorer
autocmd VimEnter *
    \ nnoremap <silent> <leader>d :CocCommand explorer --quit-on-open<CR>

" Close buffer if the only buffer left is coc-explorer
" NOTE: This fails when 1 or more pop-up window(s) are shown, which is common
" in coc-explorer.
autocmd BufEnter *
    \ if (winnr('$') == 1) && &filetype == 'coc-explorer' | q | endif

" Author: Blurgy
" Date:   Aug 01 2020
