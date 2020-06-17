" Map `mode()`'s return value to human readable format -----------------------
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
function! CurrentBranch()
    let l:command =
        \ "echo -en $(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    " Use 'echo -en' in command to eliminate trailing special character.
    let l:branch = system(l:command)
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

" Status line settings -------------------------------------------------------
" Always show the status line at the bottom, even if you only have one window
" open.
set laststatus=2
" Do not show current mode on command area
set noshowmode

" Current mode `Cmode()` and curren filename `%t`.
set stl=\ %{Cmode()}\ %#stlbg#%#fnamearea#\ %t
" Current branch `CurrentBranch()` if in a git repository.
set stl+=%#brancharea#\ %{CurrentBranch()}%#stlbg#
" Buffer modified `%M`, buffer is help doc `%H`, and buffer readonly `%R`.
set stl+=\ %M\ %H\ %R
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
