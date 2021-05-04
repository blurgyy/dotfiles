call plug#begin('~/.config/nvim/plugged')

" Prettifying vim ============================================================
" Plug 'ayu-theme/ayu-vim'                            " 'ayu' theme for vim
Plug 'morhetz/gruvbox'                              " The gruvbox colorscheme
Plug 'cocopon/iceberg.vim'                          " The Iceberg colorscheme
Plug 'itchyny/lightline.vim'                        " Lightline

" Better coding experience ===================================================
Plug 'neoclide/coc.nvim', {'branch': 'release'}     " Auto-completion
Plug 'tpope/vim-fugitive'                           " Git plugin
Plug 'airblade/vim-gitgutter'                       " Show diff when editing
" Plug 'preservim/nerdtree'                           " File explorer
" Plug 'justinmk/vim-dirvish'                         " File explorer
" Plug 'kristijanhusak/vim-dirvish-git'               " Git plugin for dirvish
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy find
Plug 'junegunn/fzf.vim'                             " Fuzzy find
Plug 'antoinemadec/coc-fzf', {'branch': 'release'}  " Fuzzy find integration
                                                    "   for coc
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
                                                    " Semantic highlighting
Plug 'p00f/nvim-ts-rainbow'                         " Highlight matched parens
Plug 'liuchengxu/vista.vim'                         " Show LSP symbols

" Language-specific plugins ==================================================
Plug 'lilydjwg/fcitx.vim', {'for': ['markdown','rst','gitcommit','tex','csv']}
                                                    " Chinese
" Seriously, language-specific plugins =======================================
Plug 'ludovicchabant/vim-gutentags'                 " Cpp
Plug 'fatih/vim-go', {'for': 'go'}                  " Golang
Plug 'rust-lang/rust.vim', {'for': 'rust'}          " rust-lang
Plug 'cespare/vim-toml', {'for': 'toml'}            " TOML

" WakaTime ===================================================================
Plug 'wakatime/vim-wakatime'                        " Track coding stats

call plug#end()

" Configuration for colorscheme ----------------------------------------------
source ~/.config/nvim/plugged/colo.init.vim
" Configuration for 'coc' ----------------------------------------------------
source ~/.config/nvim/plugged/coc.init.vim
" Configuration for 'fzf' ----------------------------------------------------
source ~/.config/nvim/plugged/fzf.init.vim
" Configuration for file explorer --------------------------------------------
source ~/.config/nvim/plugged/navi.init.vim
" Configuration for 'lightline' ----------------------------------------------
source ~/.config/nvim/plugged/lightline.init.vim
" Configuration for 'gutentags' ----------------------------------------------
source ~/.config/nvim/plugged/gutentags.init.vim
" Configuration for 'vim-gitgutter' ------------------------------------------
source ~/.config/nvim/plugged/git.init.vim
" Configuration for 'nvim-treesitter' ----------------------------------------
source ~/.config/nvim/plugged/treesitter.init.vim
" Uncategorized --------------------------------------------------------------
source ~/.config/nvim/plugged/misc.init.vim

" Author: Blurgy <gy@blurgy.xyz>
" Date:   Dec 10 2020, 09:23 [CST]
