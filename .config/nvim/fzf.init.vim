let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -l'

" If current buffer is under a git repository, find files in it; Otherwise
" find under current directory.
" From: https://github.com/junegunn/fzf.vim/issues/47#issuecomment-160237795
function! s:find_git_root()
    return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction
command! ProjectFiles execute 'Files' s:find_git_root()

" Use Ctrl-p to call above function
nnoremap <silent> <c-p> :ProjectFiles<CR>
