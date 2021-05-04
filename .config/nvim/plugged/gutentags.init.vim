" Project root patterns
let g:gutentags_project_root = ['.git', 'Makefile', '.thisisroot']
" Name of generated data file
let g:gutentags_ctags_tagfile = '.tags'
" Move all generated data file to ~/.cache/nvim/gutentags
let s:vim_tags = expand('~/.cache/nvim/gutentags')
let g:gutentags_cache_dir = s:vim_tags

" Ctags parameters yanked from: https://www.zhihu.com/question/47691414
let g:gutentags_ctags_extra_args = ['--fields=+nialmzS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--guess-language-eagerly']
let g:gutentags_ctags_extra_args += ['--kinds-c++=+px']
let g:gutentags_ctags_extra_args += ['--kinds-c=+px']

" Generate tags in most cases
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1
let g:gutentags_generate_on_write = 1
let g:gutentags_generate_on_empty_buffer = 0

" Create cache directory if it does not exist
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif

" Ignore files properly
if executable('rg')
    let g:gutentags_file_list_command = 'rg --files --hidden --ignore-files -g"!.git/"'
endif
