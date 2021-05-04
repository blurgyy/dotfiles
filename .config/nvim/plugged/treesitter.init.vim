" Install all maintained parsers and enable highlighting by default.
" Ref: https://github.com/nvim-treesitter/nvim-treesitter#user-content-modules
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = {  }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- disable = { "c", "rust" },  -- list of language that will be disabled
  },
  indent = {
    enable = true,
  },
  -- Rainbow
  -- Ref: https://github.com/p00f/nvim-ts-rainbow#user-content-setup
  rainbow = {
    enable = true,
    extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
  },
}
EOF

" Folding
" Ref: https://github.com/nvim-treesitter/nvim-treesitter#user-content-folding
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" Disable automatic folding on vim startup
set nofoldenable

" Author: Blurgy <gy@blurgy.xyz>
" Date:   Apr 23 2021, 13:36 [CST]
