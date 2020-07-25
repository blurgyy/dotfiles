" Install plugins using https://github.com/junegunn/vim-plug -----------------
set nocompatible
filetype off

" Auto download vim-plug if current home doesn't seem to have one installed.
if empty(glob("~/.local/share/nvim/site/autoload/plug.vim"))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim
        \ --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync
        \ | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

" Git plugin, also required by statusline
Plug 'tpope/vim-fugitive'
" Auto-completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Fuzzy find
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Golang
Plug 'fatih/vim-go'

" ayu theme for vim
Plug 'ayu-theme/ayu-vim'

call plug#end()

filetype plugin indent on

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
" Also, do not restore last edit position when file type is 'gitcommit'
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   if match(&filetype, "gitcommit") != 0 |
    \       exe "normal! g`\"" |
    \       call feedkeys('zz') |
    \   endif |
    \ endif

" Custom settings begin ======================================================
" Variables ------------------------------------------------------------------
let s:ft_comment = {
\     '#': [
\         'php',
\         'ruby',
\         'sh',
\         'make',
\         'cmake',
\         'perl',
\         'python',
\         'yaml',
\         'conf',
\         'dosini',
\         'gdb',
\         'readline',
\         'tmux',
\         'zsh',
\         'systemd',
\         'gitignore',
\         'gitrebase',
\         ''
\     ],
\     '//': [
\         'cpp',
\         'c',
\         'php',
\         'go',
\         'javascript',
\         'java',
\         'json',
\         'scala'
\     ],
\     '%': [
\         'tex',
\         'matlab'
\     ],
\     '>': [
\         'markdown'
\     ],
\     '"': [
\         'vim'
\     ]
\ }
" Functions ------------------------------------------------------------------
function CurrentChar()
    return getline('.')[col('.')-1]
endfunction
function NextChar()
    return getline('.')[col('.')]
endfunction
function InsideBrace()
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
function Comment()
    let s:ft = &filetype
    for comch in ['#', '//', '%', '>', '"']
        if index(s:ft_comment[comch], s:ft) != -1
            exec "silent s:^:" . comch . " :g"
            break
        endif
    endfor
    unlet s:ft
endfunction
function Uncomment()
    let s:ft = &filetype
    for comch in ['#', '//', '%', '>', '"']
        if index(s:ft_comment[comch], s:ft) != -1
            exec "silent s:^ . comch . " *::g"
            break
        endif
    endfor
    unlet s:ft
endfunction
function AppendSignature()
    exec "normal! mt"
    call append(line('$'), "")
    call append(line('$'), "Author: Blurgy")
    call append(line('$'), "Date:   ".strftime("%b %d %Y"))
    exec "$-1,$ call Comment()"
    exec "normal! 't"
endfunction

" Auto change directory when opening files in different directory
set autochdir

" Use system clipboard, need 'xclip' to be installed.
" See: ':h clipboard'
set clipboard+=unnamed,unnamedplus

" Show substitute effects as you type
set inccommand=split

" Enable undo file and directory
if !isdirectory($HOME.'/.config/nvim/undotree')
    call mkdir($HOME.'/.config/nvim/undotree', 'p', 0700)
endif
set undodir=~/.config/nvim/undotree
set undofile

" Keybindings ----------------------------------------------------------------
autocmd VimEnter * nnoremap % v%
" Center search results
autocmd VimEnter * nnoremap <silent> n nzz
autocmd VimEnter * nnoremap <silent> N Nzz
autocmd VimEnter * nnoremap <silent> * *zz
autocmd VimEnter * nnoremap <silent> # #zz
autocmd VimEnter * nnoremap <silent> g* g*zz
autocmd VimEnter * nnoremap <silent> gd gdzz
autocmd VimEnter * nnoremap <C-o> <C-o>zz
autocmd VimEnter * nnoremap <C-i> <C-i>zz
" Move single line down/up with ctrl+shift+{j,k}
" From: https://vim.fandom.com/wiki/Moving_lines_up_or_down
autocmd VimEnter * nnoremap <silent> <C-J> :m .+1<CR>==
autocmd VimEnter * nnoremap <silent> <C-K> :m .-2<CR>==
autocmd VimEnter * inoremap <silent> <C-J> <Esc>:m .+1<CR>==gi
autocmd VimEnter * inoremap <silent> <C-K> <Esc>:m .-2<CR>==gi
autocmd VimEnter * vnoremap <silent> <C-J> :m '>+1<CR>gv=gv
autocmd VimEnter * vnoremap <silent> <C-K> :m '<-2<CR>gv=gv
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
" autocmd VimEnter * inoremap <CR> <CR><Esc>:if InsideBrace()<Bar>exec "normal! ko"<Bar>endif<CR>
" Deprecated: TODO: Auto delete closing brace when cursor is inside ()/[]/{}

" Use <space> as mapleader
let mapleader = ' '
" Mapleader key bindings -----------------------------------------------------
" (Use autocmd VimEnter * <cmd> to override any plugin-defined mappings)
autocmd VimEnter * nnoremap <leader>jk :w<CR>
autocmd VimEnter * nnoremap <leader>kj :q<CR>
autocmd VimEnter * nnoremap <leader>hl :wq<CR>
autocmd VimEnter * nnoremap <leader>lh :wqa<CR>
autocmd VimEnter * nnoremap <leader>-  :sp<CR>
autocmd VimEnter * nnoremap <leader>\| :vsp<CR>
autocmd VimEnter * nnoremap <leader>n  :n<CR>
autocmd VimEnter * nnoremap <leader>N  :N<CR>
" Format python code with yapf
autocmd FileType python
    \ nnoremap <leader>y mY<Bar>:%!yapf<CR><Bar>'Yzz
" Format c/cpp code with clang-format
autocmd FileType c,cpp,javascript,java,cs
    \ nnoremap <leader>y mY<Bar>:%!clang-format<CR><Bar>'Yzz
" Remove all trailing whitespace
autocmd VimEnter *
    \ silent! nnoremap <leader>, :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let@/=_s<CR>

" Add custom header
nnoremap <silent> <leader>t :call AppendSignature()<CR>

" Comment/Uncomment
nnoremap <silent> <leader>C :call Comment()<CR>
nnoremap <silent> <leader>U :call Uncomment()<CR>

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
set nottimeout

set formatoptions=tcroqlm2
" Use 78 as textwidth, according to RFC2822
set textwidth=78
set colorcolumn=79

" Filetype-specific settings -------------------------------------------------
au VimEnter * if expand('%:t') == 'CMakeLists.txt'
    \ | set filetype=cmake
    \ | endif
au VimEnter * let fileext = expand('%:e')
    \ | if fileext == 'service' || fileext == 'nspawn' || fileext == 'slice'
    \ | set filetype=systemd
    \ | endif
au filetype gitcommit  setlocal tabstop=2 shiftwidth=2
    \ textwidth=72 colorcolumn=73
au filetype markdown   setlocal tabstop=2 shiftwidth=2
au filetype sshconfig  setlocal tabstop=2 shiftwidth=2
au filetype yaml       setlocal tabstop=2 shiftwidth=2

" Color settings -------------------------------------------------------------
" Turn on syntax highlighting.
syntax enable

" Highlight keywords in comments
" from: https://stackoverflow.com/a/30552423/13482274
augroup CommentKeywordHighlight
    au!
    au Syntax * syn match ComHi
        \ /\v\c<(fixme|must|note|only|recall|should|todo|warning)/
        \ containedin=.*Comment.*,vimCommentTitle
        \ contained
    au Syntax * syn match ComHiNegative
        \ /\v\c<(should(( ?no|n'?))t|must(( ?no|n'?))t|do(( ?no|n'?))t|can(( ?no|'?))t)/
        \ containedin=.*Comment.*,vimCommentTitle
        \ contained
augroup END
hi def link ComHiNegative ComHi
hi def link ComHi Todo

set cursorline
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
    " let ayucolor="light"  " for light version of theme
    " let ayucolor="mirage" " for mirage version of theme
    let ayucolor="dark"   " for dark version of theme
    colorscheme ayu
    hi pmenu        guibg=#27304a gui=none
    hi CocHighlightText guibg=#27304a
    hi cursorline   guibg=#352020 gui=none
    hi colorcolumn  guibg=#262626
    hi visual       guibg=#4e4a44

    " trailing whitespaces
    hi extrawhitespace guibg=#3a3a3a
elseif &t_Co == 256
    colorscheme minimalist
    hi cursorline    ctermbg=234 cterm=none
    hi colorcolumn   ctermbg=235

    " trailing whitespaces
    hi extrawhitespace ctermbg=237 guibg=237
else
    set nocursorline
    highlight colorcolumn   ctermbg=darkgray

    " trailing whitespaces
    hi extrawhitespace ctermbg=lightgray
endif

" White space settings -------------------------------------------------------
match extrawhitespace /\s\+$/
" Status line settings -------------------------------------------------------
source ~/.config/nvim/statusline.vim
" Configuration for 'coc' ----------------------------------------------------
source ~/.config/nvim/coc.init.vim
" Configuration for 'fzf' ----------------------------------------------------
source ~/.config/nvim/fzf.init.vim

" Author: Blurgy
" Date:   Jul 24 2020
