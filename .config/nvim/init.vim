if !exists('g:_nvimrc_loaded') " Prevent recursive loading of this file
let g:_nvimrc_loaded = 1

" Install plugins using https://github.com/junegunn/vim-plug -----------------
set nocompatible
filetype off

" Plugins ====================================================================
" Auto download vim-plug if current home doesn't seem to have one installed.
if empty(glob("~/.local/share/nvim/site/autoload/plug.vim"))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim
        \ --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync
        \ | source $MYVIMRC
endif

source ~/.config/nvim/plugins.init.vim

filetype plugin indent on

" Plugins end ----------------------------------------------------------------
" Configurations from https://missing.csail.mit.edu/2020/editors/ ------------

" Disable default startup message.
set shortmess+=I

" Show relative line numbers.
set number
set relativenumber

" Set backspace to work (properly).
set backspace=indent,eol,start

" Enable hidden buffer.
set hidden

" Search settings
set ignorecase
set smartcase
set incsearch

" Unbind useless/annoying default key bindings.
" 'Q' in normal mode enters Ex mode. You almost never want this.
nmap Q <Nop>

" Disable audible bell.
set noerrorbells visualbell t_vb=

" Enable mouse support.
set mouse+=a

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
" Also, do not restore last edit position when file type is 'gitcommit' or
" 'gitrebase'
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   if &filetype != "gitcommit" && &filetype != "gitrebase" |
    \       exe "normal! g`\"zz" |
    \   endif |
    \ endif

" Custom settings begin ======================================================
" Variables ------------------------------------------------------------------
let s:comchs = [
\     '#',
\     '//',
\     '%',
\     '>',
\     '"',
\     '--',
\     '..',
\ ]
let s:comment_ft = {
\     '#': [
\         '',
\         'cmake',
\         'conf',
\         'dosini',
\         'gdb',
\         'gitcommit',
\         'gitignore',
\         'gitrebase',
\         'make',
\         'map',
\         'perl',
\         'php',
\         'python',
\         'readline',
\         'resolv',
\         'ruby',
\         'sh',
\         'sshconfig',
\         'systemd',
\         'tmux',
\         'toml',
\         'yaml',
\         'zsh',
\     ],
\     '//': [
\         'c',
\         'cpp',
\         'glsl',
\         'go',
\         'java',
\         'javascript',
\         'json',
\         'php',
\         'scala',
\     ],
\     '%': [
\         'matlab',
\         'tex',
\     ],
\     '>': [
\         'markdown',
\     ],
\     '"': [
\         'vim',
\     ],
\     '--': [
\         'lua'
\     ],
\     '..': [
\         'rst'
\     ],
\ }
let s:ft_comment = {
\   '': '#',
\   'cmake': '#',
\   'conf': '#',
\   'dosini': '#',
\   'gdb': '#',
\   'gitcommit': '#',
\   'gitignore': '#',
\   'gitrebase': '#',
\   'make': '#',
\   'map': '#',
\   'perl': '#',
\   'php': '#',
\   'python': '#',
\   'readline': '#',
\   'resolv': '#',
\   'rst': '..',
\   'ruby': '#',
\   'sh': '#',
\   'sshconfig': '#',
\   'systemd': '#',
\   'tmux': '#',
\   'yaml': '#',
\   'zsh': '#',
\   'c': '//',
\   'cpp': '//',
\   'glsl': '//',
\   'go': '//',
\   'java': '//',
\   'javascript': '//',
\   'json': '//',
\   'scala': '//',
\   'matlab': '%',
\   'tex': '%',
\   'toml': '#',
\   'markdown': '>',
\   'vim': '"',
\   'lua': '--',
\ }
let s:formatters = {
\     'python': 'yapf',
\     'c': 'clang-format',
\     'cpp': 'clang-format',
\     'cs': 'clang-format',
\     'cuda': 'clang-format',
\     'glsl': 'clang-format',
\     'java': 'clang-format',
\     'javascript': 'clang-format',
\     'rust': 'rustfmt',
\ }
" Functions ------------------------------------------------------------------
function! CurrentChar()
    return getline('.')[col('.')-1]
endfunction
function! NextChar()
    return getline('.')[col('.')]
endfunction
function! InsideBrace()
    " 1 for true, 0 for false
    if CurrentChar() == '(' && NextChar() == ')'
        return 1
    elseif CurrentChar() == '[' && NextChar() == ']'
        return 1
    elseif CurrentChar() == '{' && NextChar() == '}'
        return 1
    else
        return 0
    endif
endfunction
function! Comment()
    " Skip when current line only consists of whitespaces
    if match(getline(line('.')), "^[ \t\n]*$") == 0
        return
    endif
    let s:ft = &filetype
    let s:comch = get(s:ft_comment, s:ft, '#')
    exec "normal! mC"
    exec "silent s:^[ \t\n]*::"
    exec "silent s:^:" . s:comch . " :g"
    exec "normal! ==`C"
    unlet s:ft s:comch
endfunction
function! Uncomment()
    let s:ft = &filetype
    let s:comch = get(s:ft_comment, s:ft, '#')
    " Only execute function when current line starts with comment char
    if match(getline(line('.')), "^[ \t\n]*[(".s:comch.")]\\+[ \t\n]*") == 0
        exec "normal! mC"
        exec "silent s:^[ \t\n]*" . s:comch . "[ \t\n]*::g"
        exec "normal! ==`C"
    endif
    unlet s:ft s:comch
endfunction
function! CommentToggle()
    let s:tft = &filetype
    let s:tcomch = get(s:ft_comment, s:tft, '#')
    " If current line starts with whitespaces + commentChar
    if match(getline('.'), "^[ \t\n]*" . s:tcomch . "[ \t\n]*") == 0
        call Uncomment()
    else
        call Comment()
    endif
    unlet s:tft s:tcomch
endfunction
function! CheckSigned()
    let s:ft = &filetype
    let s:comch = get(s:ft_comment, s:ft, '#')
    if getline(line('$')-2) == ''
        \ && getline(line('$')-1) =~
            \ '^' . s:comch .
            \ ' Author: Blurgy\(\( <gy@blurgy.xyz>\)\)\?$'
        if match(getline(line('$')), 'Date:   '.strftime("%b %d %Y")) != -1
            return 1 " Signature is up to date
        elseif match(getline(line('$')), s:comch . ' Date:') == 0
            return -1 " Signature is outdated
        endif
    endif
    unlet s:ft s:comch
    return 0 " Signature does not exist yet
endfunction
function! AppendSignature()
    let l:signstatus = CheckSigned()
    if l:signstatus == -1
        " " Delete outdated signature
        " call deletebufline(bufname('%'), line('$')-2, line('$'))
        " --------------------------------------------------------
        " Preserve original date of signature
        echom 'Signature is created previously.'
            \ 'To update the signature, delete the last 2 lines manually,'
            \ 'then append signature again.'
        return 1
    elseif l:signstatus == 1
        " Do nothing if signature is up to date
        echom 'Signature is created today, nothing needs to be done.'
        return 1
    else
    endif
    exec "normal! mS"
    call append(line('$'), "")
    call append(line('$'), "Author: Blurgy <gy@blurgy.xyz>")
    call append(line('$'), "Date:   ".strftime("%b %d %Y, %R [%Z]"))
    exec "$-1,$ call Comment()"
    exec "$-1,$ s:^[ \\n\\t]*::"
    exec "normal! `Szz"
    echom 'Signature is created.'
endfunction
function! SetMovementByDisplayLines()
    noremap <buffer> <silent> <expr> k v:count ? 'k' : 'gk'
    noremap <buffer> <silent> <expr> j v:count ? 'j' : 'gj'
    noremap <buffer> <silent> 0 g0
    noremap <buffer> <silent> $ g$
endfunction
function! ToggleMovementByDisplayLines()
    if !exists('b:movement_by_display_lines')
        let b:movement_by_display_lines = 0
    endif
    if b:movement_by_display_lines == 0
        call SetMovementByDisplayLines()
        let b:movement_by_display_lines = 1
        echom "Movement is now by displayed lines"
    else
        silent! nunmap <buffer> k
        silent! nunmap <buffer> j
        silent! nunmap <buffer> 0
        silent! nunmap <buffer> $
        let b:movement_by_display_lines = 0
        echom "Movement is now by actual line numbers"
    endif
endfunction
function FormatCode()
    let l:formatter = get(s:formatters, &ft, "cat")
    if l:formatter == 'cat'
        echom "No formatter is specified for filetype '".&ft."'"
    else
        let l:view = winsaveview()
        let l:current_buffer = getline(1, '$')
        let l:formatted_content = systemlist(l:formatter, l:current_buffer)
        if v:shell_error
            echo v:shell_error
            echoe 'Error occured when attempting to format current buffer'
                \ 'with `'.l:formatter.'`, contents in current buffer are'
                \ 'unchanged.'
        else
            " Do not modify buffer if already formatted
            if l:current_buffer !=# l:formatted_content
                execute '1,$delete'
                call setline(1, l:formatted_content)
            else
                echom 'Current buffer is already formatted with `'.l:formatter
                            \ .'` contents in current buffer are unchanged.'
            endif
        endif
        call winrestview(l:view)
    endif
endfunction

" Load .exrc/.vimrc/.nvimrc in current git repository root, if it extsts.
" A specific use case is to disable coc for a specific project.  To achieve
" this, add below line to the root of the project's repository:
"
"       let b:coc_enabled = 0
"
" See :h b:coc_enabled for more info.
if len(system('command -v git')) > 0
    " Use `echo -n` to remove trailing character '\n'
    let s:project_root
        \ = expand(system('echo -n $(git rev-parse --show-toplevel)'))
    if len(s:project_root) > 0
        let s:rclist = ['.exrc', '.vimrc', '.nvimrc']
        for s:file in s:rclist
            let $localrc = s:project_root . '/' . s:file
            if filereadable($localrc)
                \ && $localrc != $MYVIMRC
                source $localrc
                break
            endif
        endfor
    endif
endif

" Auto change directory when opening files in different directory
" NOTE: autochdir is disabled, as it causes problems for some plugins
" set autochdir

" Use system clipboard, need 'xclip' to be installed.
" See: ':h clipboard'
set clipboard+=unnamed,unnamedplus

" Show substitute effects as you type
if has('nvim')
    set inccommand=split
endif

" Enable undo file and directory
if !isdirectory($HOME.'/.config/nvim/undotree')
    call mkdir($HOME.'/.config/nvim/undotree', 'p', 0700)
endif
set undodir=~/.cache/nvim/undotree
set undofile

" Keybindings ----------------------------------------------------------------
autocmd VimEnter * nnoremap <silent> % v%
autocmd VimEnter * nnoremap <silent> Y y$
" Center search results
autocmd VimEnter * nnoremap <silent> n nzz
autocmd VimEnter * nnoremap <silent> N Nzz
autocmd VimEnter * nnoremap <silent> * *zz
autocmd VimEnter * nnoremap <silent> # #zz
autocmd VimEnter * nnoremap <silent> g* g*zz
autocmd VimEnter * nnoremap <silent> <C-o> <C-o>zz
autocmd VimEnter * nnoremap <silent> <C-i> <C-i>zz
" Center last insert position when using gi
autocmd VimEnter * nnoremap gi gi<ESC>zzgi
" Move single line down/up with ctrl+shift+{j,k}
" From: https://vim.fandom.com/wiki/Moving_lines_up_or_down
autocmd VimEnter * nnoremap <silent> <C-j> :m .+1<CR>=kj
autocmd VimEnter * nnoremap <silent> <C-k> :m .-2<CR>=j
autocmd VimEnter * inoremap <silent> <C-j> <Esc>:m .+1<CR>=kgi
autocmd VimEnter * inoremap <silent> <C-k> <Esc>:m .-2<CR>=jgi
autocmd VimEnter * vnoremap <silent> <C-j> :m '>+1<CR>gv=gv
autocmd VimEnter * vnoremap <silent> <C-k> :m '<-2<CR>gv=gv
" Preserve selection after indentation actions
autocmd VimEnter * vnoremap <silent> < <gv
autocmd VimEnter * vnoremap <silent> > >gv
autocmd VimEnter * vnoremap <silent> = =gv
" Preserve selection after add/minus in visual mode
autocmd VimEnter * vnoremap <silent> <C-a> <C-a>gv
autocmd VimEnter * vnoremap <silent> <C-x> <C-x>gv
" Faster scrolling
autocmd VimEnter * nnoremap <silent> <C-e> 3<C-e>
autocmd VimEnter * nnoremap <silent> <C-y> 3<C-y>
autocmd VimEnter * vnoremap <silent> <C-e> 3<C-e>
autocmd VimEnter * vnoremap <silent> <C-y> 3<C-y>
" Scroll pop up window if any pop up window is shown
" Reference:
" https://github.com/neoclide/coc.nvim/issues/2472#issuecomment-711117854
nnoremap <nowait><expr> <c-d>
            \ coc#float#has_scroll() ? coc#float#scroll(1) : "\<c-d>"
nnoremap <nowait><expr> <c-u>
            \ coc#float#has_scroll() ? coc#float#scroll(0) : "\<c-u>"
""" This is deprecated (or not)
" " Auto expand brace
" autocmd VimEnter * inoremap ( ()<Esc>i
" autocmd VimEnter * inoremap [ []<Esc>i
" autocmd VimEnter * inoremap { {}<Esc>i
" " Exit braces just by hitting the closing brace
" autocmd VimEnter * inoremap ) <Esc>:if NextChar() == ")"<Bar>exec "normal! la"<Bar>elseif NextChar() == ""<Bar>exec "normal! a)"<Bar>else<Bar>exec "normal! li)"<Bar>endif<CR>a
" autocmd VimEnter * inoremap ] <Esc>:if NextChar() == "]"<Bar>exec "normal! la"<Bar>elseif NextChar() == ""<Bar>exec "normal! a]"<Bar>else<Bar>exec "normal! li]"<Bar>endif<CR>a
" autocmd VimEnter * inoremap } <Esc>:if NextChar() == "}"<Bar>exec "normal! la"<Bar>elseif NextChar() == ""<Bar>exec "normal! a}"<Bar>else<Bar>exec "normal! li}"<Bar>endif<CR>a
" Deprecated: Auto indent when pressing <Enter> inside braces
" autocmd VimEnter * inoremap <CR> <CR><Esc>:if InsideBrace()<Bar>exec "normal! O"<Bar>endif<CR>
" Deprecated: TODO: Auto delete closing brace when cursor is inside ()/[]/{}

" Use <space> as mapleader
let mapleader = ' '
" Mapleader key bindings -----------------------------------------------------
" Use friendlier command editing interface
autocmd VimEnter * noremap <silent> <leader>: :<C-f>i
autocmd VimEnter * noremap <silent> <leader>/ /<C-f>i
autocmd VimEnter * noremap <silent> <leader>? ?<C-f>i
" (Use autocmd VimEnter * <cmd> to override any plugin-defined mappings)
autocmd VimEnter * noremap <silent> <leader>jk :w<CR>
autocmd VimEnter * noremap <silent> <leader>kj :q<CR>
autocmd VimEnter * noremap <silent> <leader>lj :qa<CR>
autocmd VimEnter * noremap <silent> <leader>jl :wq<CR>
autocmd VimEnter * noremap <silent> <leader>lh :wqa<CR>
autocmd VimEnter * noremap <silent> <leader>n  :n<CR>
autocmd VimEnter * noremap <silent> <leader>N  :N<CR>
" Clear screen and redraw
autocmd VimEnter * noremap <silent> <leader>m :mode<CR>
" Disable hlsearch until next search-related action is performed
autocmd VimEnter * noremap <silent> <leader>h :nohlsearch<CR>
" Toggle movement by displayed lines
autocmd VimEnter *
    \ noremap <silent> <leader>g :call ToggleMovementByDisplayLines()<CR>
" Append punctuation at eol
autocmd VimEnter * nnoremap <silent> <leader>;  mPA;<ESC>`P
autocmd VimEnter * nnoremap <silent> <leader>,  mPA,<ESC>`P
autocmd VimEnter * nnoremap <silent> <leader>.  mPA.<ESC>`P
" New buffer(tab)
autocmd VimEnter * nnoremap <silent> <leader>tn :tabnew<CR>
" Close current buffer(tab)
autocmd VimEnter * nnoremap <silent> <leader>tc :tabclose<CR>
" Change buffer(tab)
autocmd VimEnter * nnoremap <silent> <leader>tl :tabnext<CR>
autocmd VimEnter * nnoremap <silent> <leader>th :tabprevious<CR>
" Move tab
autocmd VimEnter * nnoremap <silent> <leader>tj :tabmove +<CR>
autocmd VimEnter * nnoremap <silent> <leader>tk :tabmove -<CR>
" Remap <leader>w to <C-w> to perform buffer actions
autocmd VimEnter * nnoremap <silent> <leader>w <C-w>
" Format code
autocmd VimEnter * nnoremap <silent>
    \ <leader>y :call FormatCode()<CR>
autocmd BufWrite * silent call FormatCode()
" Remove all trailing whitespace
autocmd VimEnter *
    \ nnoremap <silent> <leader>i
    \ mY:let _s=@/<Bar>:%s/\s\+$//e<Bar>:let@/=_s<CR>`Yzz

" Add custom header
nnoremap <silent> <leader>s :call AppendSignature()<CR>

" Comment/Uncomment
nnoremap <silent> <leader>cc :call Comment()<CR>
vnoremap <silent> <leader>cc :call Comment()<CR>gv
nnoremap <silent> <leader>cu :call Uncomment()<CR>
vnoremap <silent> <leader>cu :call Uncomment()<CR>gv
nnoremap <silent> <leader>ct :call CommentToggle()<CR>
vnoremap <silent> <leader>ct :call CommentToggle()<CR>gv
inoremap <silent> <C-_> <ESC>:call CommentToggle()<CR>
nnoremap <silent> <C-_> :call CommentToggle()<CR>
vnoremap <silent> <C-_> :call CommentToggle()<CR>gv
" Keybindings for command-line window ----------------------------------------
autocmd CmdwinEnter * nnoremap <silent> <ESC> :q<CR>
autocmd CmdwinEnter * nunmap <C-m>
autocmd CmdwinLeave * nunmap <ESC>
autocmd CmdwinLeave * nnoremap <silent> <C-m> :Marks<CR>

" Set leader key timeout to 500ms
set timeoutlen=500

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=100

" Global settings ------------------------------------------------------------
" '512: Marks will be rememberd for the last 512 edited files
" <1024: Limits the numbr of lines saved for each register to 1024 lines, if a
"       register containes more than 1024 lines, only the first 1024 lines are
"       saved.
" s512: Registers with more than 512 kB of text are skipped
" h: Disables search highlighting when Vim starts
set viminfo='512,<1024,s512,h

set confirm
set noswapfile
set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=-1

" Disable <ESC> wait time
set ttimeoutlen=0
set nottimeout

" Show tabline even when there's only 1 tab open
set showtabline=2

" Format options, see :help 'formatoptions' and :help 'fo-table' for more
" info.  Here are the descriptions of the flags currently enabled:
"
" t: Auto-wrap text using textwidth
" c: Auto-wrap comments using textwidth, inserting the current comment
"    leader automatically.
" r: Automatically insert the current comment leader after hitting
"    <Enter> in Insert mode.
" o: Automatically insert the current comment leader after hitting 'o' or
"    'O' in Normal mode.
" q: Allow formatting of comments with "gq".
"    Note that formatting will not change blank lines or lines containing
"    only the comment leader.  A new paragraph starts after such a line,
"    or when the comment leader changes.
" n: When formatting text, recognize numbered lists.
" 2: When formatting text, use the indent of the second line of a paragraph
"    for the rest of the paragraph, instead of the indent of the first
"    line.
" l: Long lines are not broken in insert mode: When a line was longer than
"    'textwidth' when the insert command started, Vim does not
"    automatically format it.
" m: Also break at a multi-byte character above 255.  This is useful for
"    Asian text where every character is a word on its own.
" B: When joining lines, don't insert a space between two multi-byte
"    characters.  Overruled by the 'M' flag.
" set formatoptions=tcroqlm2B
" Force setting formatoptions to custom value
autocmd VimEnter * set formatoptions=tcroqnlm2B
" Use 78 as textwidth, according to RFC2822 (forcibly, as some plugins messes
" this up)
autocmd VimEnter * if &filetype=='gitcommit'
            \ |     set textwidth=72
            \ | else
            \ |     set textwidth=78
            \ | endif
set colorcolumn=79

" Filetype-specific settings -------------------------------------------------
au BufEnter * if expand('%:t') == 'CMakeLists.txt'
    \ | set filetype=cmake
    \ | endif
au BufEnter * if expand('%:e') == 'tags'
    \ | set filetype=tags
    \ | endif
au BufEnter * let fext = expand('%:e')
    \ | if fext=='service' || fext=='nspawn' || fext=='slice' || fext=='timer'
    \ | set filetype=systemd
    \ | endif
au filetype gitcommit  setlocal tabstop=2 shiftwidth=2
    \ textwidth=72 colorcolumn=73
au filetype markdown   setlocal tabstop=2 shiftwidth=2
au filetype sshconfig  setlocal tabstop=2 shiftwidth=2
au filetype yaml       setlocal tabstop=2 shiftwidth=2

" Highlight keywords in comments ---------------------------------------------
" from: https://stackoverflow.com/a/30552423/13482274
augroup CommentKeywordHighlight
    au!
    au Syntax * syn match ComHi
                \ /\v\c<(fixme|must|note|only|recall|should|todo|warn((ing))?|caveat|deprecated):?>/
                \ containedin=.*Comment.*,vimCommentTitle
                \ contained
    au Syntax * syn match ComHiNegative
                \ /\v\c<(should(( ?no|n'?))t|must(( ?no|n'?))t|do(( ?no|n'?))t|can(( ?no|'?))t)>/
                \ containedin=.*Comment.*,vimCommentTitle
                \ contained
augroup END
hi def link ComHiNegative ComHi
hi def link ComHi Todo

endif " Prevent recursive loading of this file

" Author: Blurgy
" Date:   Jul 24 2020
