if set -q __ENVS_LOADED
  # Skip sourcing environments if it is already loaded
  builtin exit
end
# Variable that indicates this script is already sourced
set -x __ENVS_LOADED

##############################################################################
# Locale
set -x LC_ALL "en_US.UTF-8"

# Editor
set -x EDITOR "nvim"

# Merge program for pacdiff (from the `pacman-contrib` package)
set -x DIFFPROG "nvim -d"

# Debuginfod support, used for `coredumpctl debug`, `gdb`, etc..
set -x DEBUGINFOD_URLS "https://debuginfod.archlinux.org/"

# XDG Standards
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_CACHE_HOME $HOME/.cache

# - When using `fish_add_path`, it by default modifies the universal variable
#   `$fish_user_paths` which is prepended to `$PATH`.  Using `--prepend` and
#   `--move` jointly will cause fish to prepend unadded path to
#   `$fish_user_paths`, and move any already-added path to the first position
#   in `$fish_user_paths`.
# - Add `--path` to modify `$PATH` instead of `$fish_user_paths`.
# - Add `--global` to set `$fish_user_paths` as a global variable instead of
#   a universal (default) variable.  This is useful when using conda to manage
#   virtual environment, which does not want `$fish_user_paths` to be modified
#   by another fish session.

# `/bin` may not be in $PATH when using chroot
fish_add_path --global --path --prepend --move /bin

# Initial $MANPATH and $INFOPATH.
set -x MANPATH $MANPATH /usr/share/man
set -x INFOPATH $MANPATH /usr/share/info

# TeXlive-2021
fish_add_path --global --prepend --move /usr/local/texlive/2021/bin/x86_64-linux
set -x MANPATH $MANPATH /usr/local/texlive/2021/texmf-dist/doc/man
set -x INFOPATH $INFOPATH /usr/local/texlive/2021/texmf-dist/doc/info

# Node
fish_add_path --global --prepend --move $HOME/.node_modules/bin
set -x NODE_PATH $NODE_PATH $HOME/.node_modules

# Compiled binaries of Rust and go
fish_add_path --global --prepend --move $HOME/.cargo/bin
fish_add_path --global --prepend --move $HOME/go/bin

fish_add_path --global --prepend --move $HOME/.local/bin
fish_add_path --global --prepend --move $HOME/.gy/local/bin
fish_add_path --global --prepend --move $HOME/.gy/bin

# Settings for fzf.
# From: https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings
# Use fzf in tmux mode
set -x FZF_TMUX 1
# Use fd
set -x FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git"
set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -x FZF_CTRL_T_OPTS "--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

# Settings for skim.
# Use skim in tmux mode
set -x SKIM_TMUX 1
# Use fd
set -x SKIM_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git"
set -x SKIM_CTRL_T_COMMAND "$SKIM_DEFAULT_COMMAND"
set -x SKIM_CTRL_T_OPTS "--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

# Nord them for fzf and skim: https://github.com/ianchesal/nord-fzf
set -x FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS --color=fg:#e5e9f0,bg:#2e3440,hl:#81a1c1,fg+:#e5e9f0,bg+:#2e3440,hl+:#81a1c1,info:#eacb8a,prompt:#bf6069,pointer:#b48dac,marker:#a3be8b,spinner:#b48dac,header:#a3be8b"
set -x SKIM_DEFAULT_OPTIONS "$SKIM_DEFAULT_OPTIONS --color=fg:#e5e9f0,bg:#2e3440,hl:#81a1c1,fg+:#e5e9f0,bg+:#2e3440,hl+:#81a1c1,info:#eacb8a,prompt:#bf6069,pointer:#b48dac,marker:#a3be8b,spinner:#b48dac,header:#a3be8b"

# Set root of anaconda
set --local conda_search_path /opt/miniconda /opt/anaconda
set --local --append conda_search_path $HOME/.local/lib/miniconda3
set --local --append conda_search_path $HOME/.local/lib/miniconda
set --local --append conda_search_path $HOME/miniconda3
set --local --append conda_search_path $HOME/miniconda
set --local --append conda_search_path $HOME/.local/lib/anaconda3
set --local --append conda_search_path $HOME/.local/lib/anaconda
set --local --append conda_search_path $HOME/anaconda3
set --local --append conda_search_path $HOME/anaconda
for csp in $conda_search_path
  if test -d "$csp"
    set -x _conda_root "$csp"
  end
end

# Scroll mouse wheel to navigate within `less`
set -x LESS "--mouse --wheel-lines=3"

# Colorful man page
set -x LESS_TERMCAP_md (set_color --bold brblue --background black)
set -x LESS_TERMCAP_me (set_color normal)
set -x LESS_TERMCAP_us (set_color --underline --bold brwhite)
set -x LESS_TERMCAP_ue (set_color normal)
set -x LESS_TERMCAP_so (set_color --reverse brcyan)
set -x LESS_TERMCAP_se (set_color normal)

set -x PAGER "bat -p"

# Use less as pager for `man`, `mdcat`
set -x MANPAGER "less"
set -x MDCAT_PAGER "less"

# Github, use this jointly with .ssh/config in tracked dotfiles
set -x GH "github:blurgyy"

# WakaTime home
set -x WAKATIME_HOME $HOME/.config/wakatime

# Configuration for starship
set -x STARSHIP_CONFIG $XDG_CONFIG_HOME/starship/config.toml

# Do not generate __pycache__/ (must set to a non-empty string for this to
# take effect, see man:python(1))
set -x PYTHONDONTWRITEBYTECODE 1

# Themes for terminal applications
set -x THEME "nord"
set -x TMUX_THEME "nord"
set -x NVIM_THEME "nord"
set -x BAT_THEME "Nord"

# Servers
set -x peterpan "81.69.28.75"  # Shanghai (Tencent cloud)
set -x hooper "64.64.244.30"  # Los Angeles (GIA, 2 Cores, 1G RAM)
set -x cindy "130.162.238.248"  # Frankfurt (OCI)

# For Ubuntu machine(s):{{#if_os "id" "ubuntu"}}
fish_add_path --global --append --move $HOME/.local/chroot/usr/bin
fish_add_path --global --append --move $HOME/.local/chroot/usr/go/bin
set -x http_proxy http://192.168.1.25:9990
set -x https_proxy http://192.168.1.25:9990
# {{/if_os}}

# Author: Blurgy <gy@blurgy.xyz>
# Date:   Oct 28 2021, 14:24 [CST]
