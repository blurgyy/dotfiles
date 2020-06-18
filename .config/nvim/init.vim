" Install plugins using https://github.com/junegunn/vim-plug -----------------
set nocompatible
filetype off

if empty(glob("~/.local/share/nvim/site/autoload/plug.vim"))
    silent !curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim
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
" File explorer
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
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

nnoremap <M-d> <C-e>
nnoremap <M-u> <C-y>

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=100

" Global settings ------------------------------------------------------------
" '512: Marks will be rememberd for the last 512 edited files
" <1024: Limits the numbr of lines saved for each register to 1024 lines, if a
"       register containes mor than 1024 lines, only the first 1024 lies are saved.
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
" Set map timeout to 1000ms
set timeoutlen=1000
" Use <space> as mapleader
let mapleader = ' '

set formatoptions=tcroqlm2
" Use 78 as textwidth according to RFC2822
set textwidth=78
set colorcolumn=79

" Filetype-specific settings -------------------------------------------------
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
augroup Comment_Keyword_Highlight
    au!
    au Syntax * syn match ComHi
        \ /\v\c<(FIXME|NOTE|TODO|SHOULD|MUST|ONLY|WARNING)/
        \ containedin=.*Comment.*,vimCommentTitle
        \ contained
augroup END
hi def link ComHi Todo

" Status line settings
set cursorline
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
    colorscheme minimalist
    hi pmenu        guibg=#27304a gui=none
    hi CocHighlightText guibg=#27304a
    hi cursorline   guibg=#0c0c0c gui=none
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
" Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" Status line settings -------------------------------------------------------
source $HOME/.config/nvim/statusline.vim
" ----------------------------------------------------------------------------
" Configuration for 'coc'
source $HOME/.config/nvim/coc.init.vim
" Configuration for 'Defx'
source $HOME/.config/nvim/defx.init.vim
" Configuration for 'fzf'
source $HOME/.config/nvim/fzf.init.vim
