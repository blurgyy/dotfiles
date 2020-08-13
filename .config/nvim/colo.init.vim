colorscheme gruvbox

" Use 'hard' contrast value for gruvbox, possible values are:
" soft/medium/hard, default value is 'medium'
let g:gruvbox_contrast_dark = 'hard'

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
hi! extrawhitespace guibg=#5c5856
match extrawhitespace /\s\+$/

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
