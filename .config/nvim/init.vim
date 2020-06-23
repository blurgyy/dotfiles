" Install plugins using https://github.com/junegunn/vim-plug -----------------
set nocompatible
filetype off

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
    \   endif |
    \ endif

" Custom settings begin ======================================================

" Enable undo file and directory
if !isdirectory($HOME.'/.config/nvim/undotree')
    call mkdir($HOME.'/.config/nvim/undotree', 'p', 0700)
endif
set undodir=~/.config/nvim/undotree
set undofile

" Use <space> as mapleader
let mapleader = ' '
" Leader key bindings
nnoremap <leader>jk :w<CR>
nnoremap <leader>hl :q<CR>
nnoremap <leader>kj :wq<CR>
nnoremap <leader>lh :wqa<CR>
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
" Use 78 as textwidth according to RFC2822
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
        \ /\v\c<(fixme|note|todo|should|must|only|warning)/
        \ containedin=.*Comment.*,vimCommentTitle
        \ contained
    au Syntax * syn match ComHiNegative
        \ /\v\c<(should(( ?no|n'?))t|must(( ?no|n'?))t|do(( ?no|n'?))t|can(( ?no|'?))t)/
        \ containedin=.*Comment.*,vimCommentTitle
        \ contained
augroup END
hi def link ComHiNegative ComHi
hi def link ComHi Todo

set nocursorline
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
    colorscheme minimalist
    hi pmenu        guibg=#27304a gui=none
    hi CocHighlightText guibg=#27304a
    " Cursorline is disabled.
    " hi cursorline   guibg=#0c0c0c gui=none
    hi colorcolumn  guibg=#262626
    hi visual       guibg=#4e4a44

    " trailing whitespaces
    hi extrawhitespace guibg=#3a3a3a
elseif &t_Co == 256
    colorscheme minimalist
    " Cursorline is disabled.
    " hi cursorline    ctermbg=234 cterm=none
    hi colorcolumn   ctermbg=235

    " trailing whitespaces
    hi extrawhitespace ctermbg=237 guibg=237
else
    highlight colorcolumn   ctermbg=darkgray

    " trailing whitespaces
    hi extrawhitespace ctermbg=lightgray
endif

" White space settings -------------------------------------------------------
match extrawhitespace /\s\+$/
" Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" Status line settings -------------------------------------------------------
source ~/.config/nvim/statusline.vim
" ----------------------------------------------------------------------------
" Configuration for 'coc'
source ~/.config/nvim/coc.init.vim
" Configuration for 'fzf'
source ~/.config/nvim/fzf.init.vim
