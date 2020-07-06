" If current buffer is under a git repository, find files in it; Otherwise
" find under current directory.
" From: https://github.com/junegunn/fzf.vim/issues/47#issuecomment-160237795
function! s:find_git_root()
    return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction
command! ProjectFiles execute 'Files' s:find_git_root()

" Use Ctrl-p to call above function
nnoremap <silent> <c-p> :ProjectFiles<CR>
nnoremap <silent> <c-l> :Lines<CR>

" Open fzf in a floating window
" From: https://github.com/junegunn/fzf.vim/issues/664
function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')

  let height = float2nr(&lines * 3 / 4)
  let width = float2nr(&columns - (&columns * 2 / 10))
  let row = max({"calc":float2nr((&lines - height) / 2 - 1), "default":1})
  let col = float2nr((&columns - width) / 2)

  let opts = {
        \ 'relative': 'editor',
        \ 'row': row,
        \ 'col': col,
        \ 'width': width,
        \ 'height': height
        \ }

  call nvim_open_win(buf, v:true, opts)
endfunction

let $FZF_DEFAULT_OPTS='--layout=reverse'
let g:fzf_layout = { 'window': 'call FloatingFZF()' }
highlight NormalFloat cterm=NONE ctermfg=14 ctermbg=0 gui=NONE guifg=#93a1a1 guibg=#002931
