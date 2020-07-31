call plug#begin('~/.config/nvim/plugged')

" Git plugin, also required by statusline
Plug 'tpope/vim-fugitive'
" Auto-completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" File explorer
Plug 'preservim/nerdtree'
" Fuzzy find
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Golang
Plug 'fatih/vim-go'
" rust-lang
Plug 'rust-lang/rust.vim'

" ayu theme for vim
Plug 'ayu-theme/ayu-vim'

call plug#end()

" Configuration for 'coc' ----------------------------------------------------
source ~/.config/nvim/coc.init.vim
" Configuration for 'fzf' ----------------------------------------------------
source ~/.config/nvim/fzf.init.vim
" Configuration for 'nerdtree'
source ~/.config/nvim/nerdtree.init.vim
