if set -q __ABBRS_LOADED; and not set -q __FORCE_UPDATE_ABBRS
  # Skip load abbrs if it is already loaded and it is not a force reload
  builtin exit
end
# Variable that indicates this script is already sourced
set -x __ABBRS_LOADED

##############################################################################
# Typoes #####################################################################
##############################################################################
# Index:
#   - blurgy
#   - cat
#   - cd
#   - git
#   - gpp (g++)
#   - ll
#   - ls
#   - make
#   - meli
#   - paru
#   - sudo
#   - vim

set blurgy_typoes \
  bluryg \
  lburgy
for typo in $blurgy_typoes; abbr $typo blurgy; end

set cd_typoes \
  c \
  ccd \
  cdc \
  cdd \
  cde \
  ce \
  lcd \
  vcd
for typo in $cd_typoes; abbr $typo cd; end

set git_typoes \
  gi \
  gi \
  it
for typo in $git_typoes; abbr $typo git; end

set gpp_typoes \
  g+ \
  g+= \
  g=+ \
  g_ \
  g__
for typo in $gpp_typoes; abbr $typo g++; end

set ll_executable \
  (
    if type -q exa
      echo exa -lhgF --icons
    else
      echo ls -alhCF
    end
  )
set ll_typoes \
  lll
for typo in $ll_typoes; abbr $typo $ll_executable; end

set ls_executable \
  (if type -q exa; echo exa -F; else; echo ls; end)
set ls_typoes \
  lks \
  lls \
  lsc \
  lsl \
  s \
  sl
for typo in $ls_typoes; abbr $typo $ls_executable; end

set make_typoes \
  amek \
  amke \
  maek \
  mak \
  makje \
  mkae \
  mke
for typo in $make_typoes; abbr $typo make; end

set meli_typoes \
  meil
for typo in $meli_typoes; abbr $typo meli; end

set paru_typoes \
  aprpu \
  aprru \
  apru \
  apur \
  arpu \
  aru \
  paaru \
  parru \
  paruu \
  pru \
  paur
for typo in $paru_typoes; abbr $typo paru; end

set sudo_typoes \
  sdo \
  sduo \
  suddo \
  sudi \
  sudoo \
  sudp \
  sudu \
  suod \
  susdo \
  suso \
  suudo \
  usdo
for typo in $sudo_typoes; abbr $typo sudo; end

set vim_typoes \
  bim \
  cim \
  fim \
  fvim \
  im \
  ivim \
  ivm \
  v \
  viam \
  viim \
  vij \
  vijm \
  vikm \
  vimi \
  vimj \
  vimk \
  vimm \
  vin \
  viom \
  vium \
  vivm \
  vjim \
  vjm \
  vjmm \
  vkim \
  vkm \
  vkmm \
  vm \
  vmi \
  vmj \
  vmk \
  voim \
  vom \
  vuim \
  vum \
  vun \
  vvim
set vi_executable \
  (if type -q nvim; echo nvim; else; echo vim; end)
for typo in $vim_typoes; abbr $typo $vi_executable; end

##############################################################################
# Shorthands #################################################################
##############################################################################

abbr rm 'rm -Iv'
abbr mv 'mv -v'
abbr cp 'cp -v'
# abbr alert 'notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Exa ------------------------------------------------------------------------
if type -q exa
  abbr exa 'exa -F'
  abbr ls 'exa -F'
  abbr ll 'exa -lhgF --icons'
  abbr la 'exa -aF'
  abbr lla 'exa -alhgF --icons'
  abbr l 'exa -F'
  abbr tree 'exa -TF --icons'
else
  abbr ls 'ls -CF'
  abbr ll 'ls -alhCF'
  abbr la 'ls -ACF'
  abbr l 'ls -CF'
end

# Bat pager ------------------------------------------------------------------
if type -q bat
  abbr caat 'bat'
  abbr catt 'bat'
  abbr ccat 'bat'
  abbr cat 'bat'
  abbr dmesg 'sudo dmesg -TL=always | bat -n'
else
  abbr caat 'cat'
  abbr catt 'cat'
  abbr ccat 'cat'
  abbr dmesg 'sudo dmesg -T'
end

# Git ------------------------------------------------------------------------
abbr g 'git'
abbr ga 'git add'
abbr ga. 'git add .'
abbr ga.. 'git add ..'
abbr ga... 'git add ../..'
abbr ga.... 'git add ../../..'
abbr ga..... 'git add ../../../..'
abbr gaa 'git add -A'
abbr gb 'git branch'
abbr gbs 'git branch --set-upstream-to'

abbr gc 'git commit -sv'
abbr gca 'git commit -sv --amend'
abbr gcan 'git commit -sv --amend --no-edit'

abbr gcnosign 'git commit -sv --no-gpg-sign'
abbr gcanosign 'git commit -sv --amend --no-gpg-sign'
abbr gcannosign 'git commit -sv --amend --no-edit --no-gpg-sign'
abbr gcinit 'git commit --allow-empty -m "chore: initalize repository (empty)"'

abbr gco 'git checkout'
abbr gco. 'git checkout .'
abbr gd 'git diff'
abbr ggd 'git diff'
abbr gdc 'git diff --cached'
abbr gddc 'git diff --cached'
abbr gdh 'git diff HEAD^ HEAD'
abbr gf 'git fetch'
abbr gl 'git log --all --graph --decorate --oneline -8'
abbr gln 'git log --all --graph --decorate --oneline'
abbr lg 'git log --all --graph --decorate --oneline -8'
abbr lgl 'git log --all --graph --decorate --oneline -8'
abbr gla 'git log --all --graph --decorate --format=fuller'
abbr glad 'git log --all --graph --decorate --format=fuller --patch --ext-diff'
abbr glap 'git log --all --graph --decorate --format=fuller --patch'
abbr gll 'git pull'
abbr gp 'git push'
abbr gfp 'git push --force'
abbr gpf 'git push --force'
abbr gs 'git status'
abbr gsl 'git status && git log --all --graph --decorate --oneline -8'
abbr gbisect 'git bisect'
abbr gclone 'git clone'
abbr gshow 'git show'
abbr gmerge 'git merge --signoff --verbose --no-edit'
abbr gmergenosign 'git merge --signoff --verbose --no-edit --no-gpg-sign'
abbr gmt 'git mergetool'
abbr grebase 'git rebase --committer-date-is-author-date'
abbr greset 'git reset'
abbr gstash 'git stash'
abbr gunstage 'git reset HEAD --'
abbr ginit 'git init'
abbr gremote 'git remote'
abbr grevert 'git revert --signoff --no-edit'

# TMUX
abbr lscli 'tmux list-clients'
abbr lss 'tmux list-sessions'
abbr lsw 'tmux list-windows'
abbr lsp 'tmux list-panes'
abbr sw 'tmux swap-window -dt'

# Cargo ----------------------------------------------------------------------
# build
abbr cb 'cargo build'
abbr cbd 'cargo build --debug'
abbr cbr 'cargo build --release'
# install
abbr ci 'cargo install'
abbr cid 'cargo install --debug'
abbr cir 'cargo install --release'
# run
abbr cr 'cargo run'
abbr crd 'cargo run --debug'
abbr crr 'cargo run --release'
# test
abbr ct 'cargo test'
abbr ctb 'ct --build'
abbr ctr 'ct --release'

# https://github.com/blurgyy/tinytools
abbr bak 'tt bak'
abbr debak 'tt debak'

# Miscellaneous --------------------------------------------------------------
abbr black '/usr/bin/black'
abbr bpvc 'pelican -rl'
abbr cf 'clang-format'
abbr cgls 'systemd-cgls'
abbr dingtalk 'systemctl --user start dingtalk.service'
abbr dl 'axel -n 16'
abbr du 'dua interactive'
abbr dvim "$vi_executable -V10/tmp/vim-debug.log"
abbr feh "feh --auto-rotate --conversion-timeout=1"
abbr fgfg "fg"
abbr g++ 'g++ -Wall'
abbr gcc 'gcc -Wall'
abbr ghc 'ghc -dynamic -outputdir=/tmp/ghc'
abbr gpustat 'gpustat --force-color -cpuFi 1 -P "draw,limit"'
abbr hibernate 'systemctl hibernate'
abbr ip 'ip -br -c'
abbr jobs 'jobs -l'
abbr js 'sudo journalctl --system'
abbr jsu 'sudo journalctl --system -u'
abbr ju 'journalctl --user'
abbr juu 'journalctl --user -u'
abbr km 'make'
abbr lkm 'latexmk'
abbr lmk 'latexmk'
abbr lpvc 'latexmk -pvc'
abbr lpvcc 'yes x | latexmk -pvc'
abbr mk 'make'
abbr mtr 'mtr -n'
abbr n 'node'
abbr npm 'pnpm'
abbr nvrun '__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia'
abbr open 'xdg-open'
abbr p2 'python2 -u'
abbr p 'python3 -u'
abbr parallel 'parallel -u'
abbr px 'cgproxy'
abbr pxx 'cgnoproxy'
abbr qfg 'fg'
abbr rsync 'rsync -aAHXv'
abbr sus 'systemctl --user'
abbr sys 'sudo systemctl --system'
abbr today 'date +"%Y-%m-%d"'
abbr ts 'PYTHONWARNINGS=ignore telegram-send --timeout 86400'
abbr vi "$vi_executable"
abbr vim "$vi_executable"
abbr vimlite "$vi_executable -u NONE"
abbr watch 'watch -n 0.2 -c'
abbr wget.k 'wget --no-check-certificate'
abbr z 'zathura'
abbr zathura 'zathura --fork 2>/dev/null'

# Author: Blurgy <gy@blurgy.xyz>
# Date:   Oct 28 2021, 14:50 [CST]
