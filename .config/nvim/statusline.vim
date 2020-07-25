" Map `mode()`'s return value to human readable format -----------------------
let current_mode = {
    \ "n"       : "Normal",
    \ "no"      : "Normal·Operator Pending",
    \ "v"       : "Visual",
    \ "V"       : "V-Line",
    \ "\<C-V>"  : "V-Block",
    \ "s"       : "Select",
    \ "S"       : "S-Line",
    \ "\<C-S>"  : "S-Block",
    \ "i"       : "Insert",
    \ "R"       : "Replace",
    \ "Rv"      : "V-Replace",
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
    return toupper(g:current_mode[mode()])
endfunction

" Returns current branch
" Requires tpope/vim-fugitive to be installed
function! CurrentBranch()
    let l:branch = FugitiveHead()
    if strlen(l:branch) > 0
        let l:message = "[" . l:branch . "] "
    else
        let l:message = ""
    endif
    return l:message
endfunction

" Returns file type
function! ThisFileType()
    let l:tft = &filetype
    if strlen(l:tft) == 0
        let l:tft = "noft"
    endif
    return l:tft
endfunction

function! ThisFileModified()
    return &modified == 1 ? '+ ' : ''
endfunction

" Highlights -----------------------------------------------------------------
if exists('+termguicolors')
    hi clear statusline
    " Different colors for different modes.
    hi insertcolo   guibg=#ffffff guifg=#005e55 gui=bold
    hi visualcolo   guibg=#ff8807 guifg=#880300 gui=bold
    hi replacecolo  guibg=#005e55 guifg=#ffffff gui=bold
    " All other mode including NORMAL, COMMAND, etc. are highlighted as below.
    hi misccolo     guibg=#b0e10a guifg=#006500 gui=bold

    " Highlight scheme when not in INSERT mode.
    hi fnamearea    guibg=#424242 guifg=#f1f1f1
    hi brancharea   guibg=#424242 guifg=#87d7ff gui=bold
    hi percarea     guibg=#424242 guifg=#eeeeee
    hi stlbg        guibg=#262626 guifg=#797979

    " Special behaviour when entering and leaving INSERT mode.
    au InsertEnter * hi fnamearea   guibg=#0087af guifg=#ffffff
                \ | hi brancharea   guibg=#0087af guifg=#ffffff gui=bold
                \ | hi stlbg        guibg=#005f88 guifg=#5cb2d8
                \ | hi percarea     guibg=#0087af guifg=#a7ffff
    au InsertLeave * hi fnamearea   guibg=#424242 guifg=#f1f1f1
                \ | hi brancharea   guibg=#424242 guifg=#87d7ff gui=bold
                \ | hi percarea     guibg=#424242 guifg=#eeeeee
                \ | hi stlbg        guibg=#262626 guifg=#797979
elseif &t_Co == 256
    hi fnamearea    ctermbg=237 ctermfg=255
    hi brancharea   ctermbg=237 ctermfg=117 cterm=bold
    hi percarea     ctermbg=237 ctermfg=255
    hi stlbg        ctermbg=235 ctermfg=241

    " Change bg color mod mode area on status line, depending on whether
    " current mode is 'INSERT' or not
    hi clear statusline
    hi statusline ctermbg=228 ctermfg=232 cterm=none
    au InsertEnter * hi statusline ctermbg=117 ctermfg=232 cterm=none
    au InsertLeave * hi statusline ctermbg=228 ctermfg=232 cterm=none
else
    hi fnamearea    ctermbg=darkgray    ctermfg=white
    hi brancharea   ctermbg=darkgray    ctermfg=lightblue
    hi percarea     ctermbg=darkgray    ctermfg=white
    hi stlbg        ctermbg=black       ctermfg=darkgray

    " Change bg color mod mode area on status line, depending on whether
    " current mode is 'INSERT' or not
    hi clear statusline
    hi statusline ctermbg=yellow ctermfg=black cterm=none

    au InsertEnter * hi statusline ctermbg=lightblue ctermfg=black cterm=none
    au InsertLeave * hi statusline ctermbg=yellow ctermfg=black cterm=none
endif

" Status line settings -------------------------------------------------------
" Always show the status line at the bottom, even if you only have one window
" open.
set laststatus=2
" Do not show current mode on command area
set noshowmode

set stl=
" Different color schemes for different modes
if exists('+termguicolors')
    set stl+=%#insertcolo#%{mode()=='i'?'\ \ INSERT\ ':''}
    set stl+=%#replacecolo#%{mode()=='R'?'\ \ REPLACE\ ':''}
    set stl+=%#visualcolo#%{mode()=='v'?'\ \ '.Cmode().'\ ':''}
    set stl+=%#visualcolo#%{Cmode()=='V-BLOCK'?'\ \ V-BLOCK\ ':''}
    set stl+=%#misccolo#%{mode()=='n'?'\ \ NORMAL\ ':''}
    set stl+=%#misccolo#%{mode()=='c'?'\ \ COMMAND\ ':''}
    set stl+=%#misccolo#%{mode()=='t'?'\ \ TERMINAL\ ':''}
else
    set stl=\ %{Cmode()}\ %#stlbg#%#fnamearea#\ %t
endif
" Display filename.
set stl+=%#fnamearea#\ %t
" Current branch `CurrentBranch()` if in a git repository.
set stl+=%#brancharea#\ %{CurrentBranch()}%#stlbg#
" Buffer modified `%M`, buffer is help doc `%H`, and buffer readonly `%R`.
set stl+=\ %{ThisFileModified()}%H%R
" Set right aligned items.
set stl+=%=
" Fileformat and file encoding.
set stl+=%{&fileformat}\ \|\ %{(&fileencoding!=''?&fenc:&enc)}
" File syntax.
set stl+=\ \|\ %{ThisFileType()}
" Percentage of current line in the whole buffer.
set stl+=\ %#percarea#\ %3p%%\ %#stlbg#
" Current position in buffer.
set stl+=\ %4l:%-3c

" Author: Blurgy
" Date:   Jul 24 2020
