" let ayucolor="light"  " for light version of theme
" let ayucolor="mirage" " for mirage version of theme
let ayucolor="dark"   " for dark version of theme
colorscheme ayu

" Turn on syntax highlighting.
syntax enable

" White space settings -------------------------------------------------------
if ayucolor == 'light'
    hi! extrawhitespace guibg=#dddddd
elseif ayucolor == 'mirage'
    hi! extrawhitespace guibg=#544b58
elseif ayucolor == 'dark'
    hi! extrawhitespace guibg=#3a3a3a
endif
match extrawhitespace /\s\+$/

set cursorline
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

if ayucolor == 'dark'
    hi! cursorline   guibg=#352020 gui=none
    hi! colorcolumn  guibg=#262626
endif

" Author: Blurgy
" Date:   Jul 31 2020
