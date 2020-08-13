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
        let l:message = "[" . l:branch . "]"
    else
        let l:message = ""
    endif
    return l:message
endfunction

let g:lightline#ale#indicator_checking = "..."
" let g:lightline#ale#indicator_infos = "\uf129"
" let g:lightline#ale#indicator_warnings = "\uf071"
" let g:lightline#ale#indicator_errors = "\uf05e"
" let g:lightline#ale#indicator_ok = "\uf00c"

let g:lightline = {
\ 'colorscheme': 'gruvbox',
\ 'active': {
\   'left': [ [ 'mode', 'gitbranch', 'paste', 'cocstatus' ],
\             [ 'filename', 'linter_checking', 'linter_errors',
\               'linter_warnings', 'linter_infos', 'readonly', 'modified' ] ]
\   },
\ 'component_function': {
\   'cocstatus': 'coc#status',
\   'gitbranch': 'CurrentBranch'
\   },
\ 'component_expand' : {
\   'linter_checking': 'lightline#ale#checking',
\   'linter_infos': 'lightline#ale#infos',
\   'linter_warnings': 'lightline#ale#warnings',
\   'linter_errors': 'lightline#ale#errors',
\   },
\ 'component_type' : {
\   'linter_checking': 'right',
\   'linter_infos': 'right',
\   'linter_warnings': 'warning',
\   'linter_errors': 'error',
\   }
\ }

" Author: Blurgy
" Date:   Jul 31 2020
