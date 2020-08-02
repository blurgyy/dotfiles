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
nnoremap <silent> <c-b> :Buffers<CR>
nnoremap <silent> <CR>  :Marks<CR>

" Open fzf in a floating window
" From: https://github.com/neovim/neovim/issues/9718#issuecomment-559573308
function! CreateCenteredFloatingWindow()
    let width = min([&columns - 4, max([80, &columns - 20])])
    let height = min([&lines - 4, max([20, &lines - 10])])
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰" . repeat("─", width - 2) . "╯"
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
endfunction

let $FZF_DEFAULT_OPTS='--layout=reverse'
let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }
highlight NormalFloat cterm=NONE ctermfg=14 ctermbg=0 gui=NONE guifg=#93a1a1 guibg=#002931
