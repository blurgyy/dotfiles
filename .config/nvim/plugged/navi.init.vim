" Coc-explorer ===============================================================
" Use <leader>d to toggle coc-explorer
autocmd BufEnter *
    \ nnoremap <silent> <leader>d :CocCommand explorer --quit-on-open<CR>

" Close buffer if the only buffer left is coc-explorer
" NOTE: This fails when 1 or more pop-up window(s) are shown, which is common
" in coc-explorer.
autocmd BufEnter *
    \ if (winnr('$') == 1) && &filetype == 'coc-explorer' | q | endif

" Vista.vim ==================================================================
let g:vista_sidebar_width = 50
let g:vista_cursor_delay = 400
" Use ctags (universal-ctags) as default executable for Vista.vim
let g:vista_default_executive = 'ctags'
" Display detailed information of current cursor symbol in a floating window
let g:vista_echo_cursor_strategy = 'floating_win'
" Do not move cursor when opening a vista window
let g:vista_stay_on_open = 0
" Disable fancy icons that need extra fonts.
let g:vista#renderer#enable_icon = 0

" " Open vista window on BufRead
" autocmd BufRead * Vista
" Use <leader>o to toggle document tree
autocmd BufEnter * nnoremap <silent> <leader>v :Vista!!<CR>
" Close buffer if the only buffer left is Vista.vim's document tree
autocmd BufEnter *
    \ if (winnr('$') == 1) &&
    \ (&filetype == 'vista' || &filetype =~ 'vista.*') | q | endif

" Author: Blurgy
" Date:   Aug 01 2020
