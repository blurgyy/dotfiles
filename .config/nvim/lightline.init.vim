" Always show the status line at the bottom, even if you only have one window
" open.
set laststatus=2
" Do not show current mode on command line
set noshowmode

" let g:lightline = {
" \ 'colorscheme': 'ayu'
" \ }

" Returns current branch
" Requires tpope/vim-fugitive to be installed
function! CurrentBranch()
    let l:branch = FugitiveHead()
    if strlen(l:branch) > 0
        let l:message = "[branch:" . l:branch . "]"
    else
        let l:message = ""
    endif
    return l:message
endfunction

let g:lightline = {
\ 'colorscheme': ayucolor=='light'||ayucolor=='mirage'?'ayu_'.ayucolor:'powerline',
\ 'active': {
\   'left': [ [ 'mode', 'paste', 'cocstatus' ],
\             [ 'filename', 'gitbranch', 'readonly', 'modified' ] ]
\ },
\ 'component_function': {
\   'cocstatus': 'coc#status',
\   'gitbranch': 'CurrentBranch'
\ },
\ }

" Author: Blurgy
" Date:   Jul 31 2020
