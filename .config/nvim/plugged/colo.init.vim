" Use 'hard' contrast value for gruvbox, possible values are:
" soft/medium/hard, default value is 'medium'
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_contrast_light = 'hard'
let g:gruvbox_improved_strings = 1
let g:gruvbox_italic = 1
let g:gruvbox_italicize_strings = 1

colorscheme gruvbox

" Use dark theme for gruvbox
set bg=dark

" Turn on syntax highlighting.
syntax enable

" White space settings -------------------------------------------------------
" if ayucolor == 'light'
" hi! extrawhitespace guibg=#dddddd
" elseif ayucolor == 'mirage'
" hi! extrawhitespace guibg=#544b58
" elseif ayucolor == 'dark'
" hi! extrawhitespace guibg=#3a3a3a
" endif
if &bg == 'dark'
    autocmd BufEnter * hi! extrawhitespace guibg=#5c5856
else
    autocmd BufEnter * hi! extrawhitespace guibg=#ab9b72
endif
autocmd BufEnter * match extrawhitespace /\s\+$/

" Use Pmenu highlight for CocFloating, because gruvbox does not seem to
" provide light theme NormalFloat highlighting, which makes the floating
" window in Coc very ugly.
highlight link CocFloating Pmenu

set cursorline
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

" hi! cursorline   guibg=#352020 gui=none
" hi! colorcolumn  guibg=#262626

" Author: Blurgy
" Date:   Jul 31 2020
