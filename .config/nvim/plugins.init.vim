call plug#begin('~/.config/nvim/plugged')

" Prettifying vim ============================================================
" Plug 'ayu-theme/ayu-vim'                            " 'ayu' theme for vim
Plug 'morhetz/gruvbox'                              " The gruvbox colorscheme
Plug 'itchyny/lightline.vim'                        " Lightline

" Better coding experience ===================================================
Plug 'dense-analysis/ale', {'for': 'rust'}          " Linting engine
Plug 'maximbaz/lightline-ale', {'for': 'rust'}      " Lightline + ALE
Plug 'neoclide/coc.nvim', {'branch': 'release'}     " Auto-completion
Plug 'tpope/vim-fugitive'                           " Git plugin
" Plug 'preservim/nerdtree'                           " File explorer
" Plug 'justinmk/vim-dirvish'                         " File explorer
" Plug 'kristijanhusak/vim-dirvish-git'               " Git plugin for dirvish
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy find
Plug 'junegunn/fzf.vim'                             " Fuzzy find
Plug 'antoinemadec/coc-fzf', {'branch': 'release'}  " Fuzzy find integration
                                                    "   for coc
Plug 'sheerun/vim-polyglot'                         " Semantic highlighting

" Language-specific plugins ==================================================
Plug 'lilydjwg/fcitx.vim', {'for': 'markdown'}      " Chinese
" Seriously, language-specific plugins =======================================
Plug 'gabrielelana/vim-markdown',{'for':'markdown'} " Markdown
" Plug 'ludovicchabant/vim-gutentags'                 " Cpp
Plug 'fatih/vim-go', {'for': 'go'}                  " Golang
Plug 'rust-lang/rust.vim', {'for': 'rust'}          " rust-lang
Plug 'cespare/vim-toml', {'for': 'toml'}            " TOML

call plug#end()

" Configuration for colorscheme ----------------------------------------------
source ~/.config/nvim/colo.init.vim
" Configuration for 'coc' ----------------------------------------------------
source ~/.config/nvim/coc.init.vim
" Configuration for 'fzf' ----------------------------------------------------
source ~/.config/nvim/fzf.init.vim
" Configuration for file explorer --------------------------------------------
source ~/.config/nvim/navi.init.vim
" Configuration for 'lightline' ----------------------------------------------
source ~/.config/nvim/lightline.init.vim
" Configuration for 'gutentags' ----------------------------------------------
source ~/.config/nvim/gutentags.init.vim
