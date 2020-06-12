" Install plugins using https://github.com/junegunn/vim-plug -----------------
set nocompatible
filetype off

call plug#begin('~/.config/nvim/plugged')

" git plugin for vim
Plug 'tpope/vim-fugitive'
" Auto-completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" File explorer
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
" Fuzzy find
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

filetype plugin indent on

" Configurations from https://missing.csail.mit.edu/2020/editors/

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

" Do this in normal mode...
nnoremap <Left>  :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up>    :echoe "Use k"<CR>
nnoremap <Down>  :echoe "Use j"<CR>
" ...and in insert mode
inoremap <Left>  <ESC>:echoe "Use h"<CR>
inoremap <Right> <ESC>:echoe "Use l"<CR>
inoremap <Up>    <ESC>:echoe "Use k"<CR>
inoremap <Down>  <ESC>:echoe "Use j"<CR>

" Custom settings begin ======================================================

" Map `mode()`'s return value to human readable format -------------------
let g:current_mode = {
    \ "n"       : "Normal",
    \ "no"      : "Normal·Operator Pending",
    \ "v"       : "Visual",
    \ "V"       : "V·Line",
    \ "\<C-V>"  : "V·Block",
    \ "s"       : "Select",
    \ "S"       : "S·Line",
    \ "\<C-S>"  : "S·Block",
    \ "i"       : "Insert",
    \ "R"       : "Replace",
    \ "Rv"      : "V·Replace",
    \ "c"       : "Command",
    \ "cv"      : "Vim Ex",
    \ "ce"      : "Ex",
    \ "r"       : "Prompt",
    \ "rm"      : "More",
    \ "r?"      : "Confirm",
    \ "!"       : "Shell",
    \ "t"       : "Terminal"
\}

" Functions ------------------------------------------------------------------
" Returns current mode
function! Cmode()
    let message = toupper(g:current_mode[mode()])
    return message
endfunction

" Returns current branch
" Requires vim-fugitive to be installed
function! CurrentBranch()
    let l:branch = FugitiveHead()
    if strlen(l:branch) > 0
        let l:message = "(" . l:branch . ") "
    else
        let l:message = ""
    endif
    return l:message
endfunction

function! ColorMode()
    let cmode = Cmode()
    if cmode == "NORMAL"
        let ret = "%1*"
    else
        let ret = "%2*"
    endif
    return ret.'\ '.cmode.'\ %*'
endfunction

function! Cmode()
    let message = toupper(g:current_mode[mode()])
    return message
endfunction

function! CurrentBranch()
    let l:branch = FugitiveHead()
    if strlen(l:branch) > 0
        let l:message = "[" . l:branch . "] "
    else
        let l:message = ""
    endif
    return l:message
endfunction

function! ColorMode()
    let cmode = Cmode()
    if cmode == "NORMAL"
        let ret = "%1*"
    else
        let ret = "%2*"
    endif
    return ret.'\ '.cmode.'\ %*'
endfunction

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
set ttimeoutlen=0 timeoutlen=0

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
    au Syntax * syn match ComHi /\v\c<(FIXME|NOTE|TODO|SHOULD|ONLY)/
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
    hi cursorline    guibg=#0c0c0c gui=none
    hi colorcolumn   guibg=#262626

    " Status line highlighting
    hi fnamearea     guibg=#3a3a3a guifg=#eeeeee
    hi brancharea    guibg=#3a3a3a guifg=#87d7ff gui=bold
    hi percarea      guibg=#3a3a3a guifg=#eeeeee
    hi stlbg         guibg=#262626 guifg=#6a6a6a

    " trailing white spaces
    hi extrawhitespace guibg=#3a3a3a

    " Change bg color mod mode area on status line, based on current mode is
    " 'INSERT' or not
    hi clear statusline
    hi statusline guibg=#ffff87 guifg=#1c1c1c gui=none
    au InsertEnter * hi statusline guibg=#87d7ff guifg=#1c1c1c gui=none
    au InsertLeave * hi statusline guibg=#ffff87 guifg=#1c1c1c gui=none
elseif &t_Co == 256
    colorscheme minimalist
    hi cursorline    ctermbg=234 cterm=none
    hi colorcolumn   ctermbg=235

    " Status line highlighting
    hi fnamearea     ctermbg=237 ctermfg=255
    hi brancharea    ctermbg=237 ctermfg=117 cterm=bold
    hi percarea      ctermbg=237 ctermfg=255
    hi stlbg         ctermbg=235 ctermfg=241

    " trailing white spaces
    hi extrawhitespace ctermbg=237 guibg=237

    " Change bg color mod mode area on status line, based on current mode is
    " 'INSERT' or not
    hi clear statusline
    hi statusline ctermbg=228 ctermfg=232 cterm=none
    au InsertEnter * hi statusline ctermbg=117 ctermfg=232 cterm=none
    au InsertLeave * hi statusline ctermbg=228 ctermfg=232 cterm=none
    " CmdlineEnter/Leave do not work well with auto-completion plugins.
    "au CmdlineEnter * hi statusline ctermbg=190 ctermfg=232 cterm=none|redraw
    "au CmdlineLeave * hi statusline ctermbg=219 ctermfg=232 cterm=none|redraw
else
    set nocursorline
    highlight colorcolumn   ctermbg=darkgray

    " Status line highlighting
    hi fnamearea     ctermbg=darkgray    ctermfg=white
    hi brancharea    ctermbg=darkgray    ctermfg=lightblue
    hi percarea      ctermbg=darkgray    ctermfg=white
    hi stlbg         ctermbg=black       ctermfg=darkgray

    " trailing white spaces
    hi extrawhitespace ctermbg=lightgray

    " Change bg color mod mode area on status line, based on current mode is
    " 'INSERT' or not
    hi clear statusline
    hi statusline ctermbg=yellow ctermfg=black cterm=none

    au InsertEnter * hi statusline ctermbg=lightblue ctermfg=black cterm=none
    au InsertLeave * hi statusline ctermbg=yellow ctermfg=black cterm=none
    " CmdlineEnter/Leave do not work well with auto-completion plugins.
    "au CmdlineEnter * hi statusline ctermbg=yellow ctermfg=black cterm=none|redraw
    "au CmdlineLeave * hi statusline ctermbg=green ctermfg=black cterm=none|redraw
endif

" White space settings -------------------------------------------------------
match extrawhitespace /\s\+$/
" Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" Status line settings -------------------------------------------------------
" Always show the status line at the bottom, even if you only have one window
" open.
set laststatus=2
" Do not show current mode on command area
set noshowmode
" `stl` stands for `statusline`
set stl=
set stl+=\ %{Cmode()}\ %#stlbg#
set stl+=%#fnamearea#
set stl+=\ %t
set stl+=%#brancharea#
set stl+=\ %{CurrentBranch()}
set stl+=%#stlbg#
set stl+=\ %M
set stl+=\ %H
set stl+=\ %R

set stl+=%=
set stl+=%{&fileformat}
set stl+=\ \|\ %{(&fileencoding!=''?&fenc:&enc)}
set stl+=\ \|\ %Y
set stl+=\ %#percarea#\ %3p%%\ %#stlbg#
set stl+=\ %4l:%-3c

" ----------------------------------------------------------------------------
" Configuratoin for 'coc'
source $HOME/.config/nvim/coc.init.vim
" Configuratoin for 'Defx'
source $HOME/.config/nvim/defx.init.vim
" Configuration for 'fzf'
source $HOME/.config/nvim/fzf.init.vim
