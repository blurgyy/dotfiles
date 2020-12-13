#!/bin/sh

# From /etc/X11/xinit/xinitrc ################################################
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Custom configs #############################################################
# Local xinitrc files to load, no need to worry about if '~/.xinitrc.*' does
# not exist, as xinit (seems to) ignores error in .xinitrc.
for i in ~/.xinitrc.*; do
    source $i
done

# Compositor
command -v picom >/dev/null && picom -cb

# Log directories
_logdir=~/.gy/local/log

# Input method
mkdir -p "$_logdir"/fcitx5 \
    && fcitx5 1>"$_logdir/fcitx5/log" 2>"$_logdir/fcitx5/err" &

# Clone git@github.com:adi1090x/polybar-themes.git and symlink one of the
# themes to `~/.config/polybar` to use polybar
_polybar_base=~/.config/polybar
if [[ -d "$_polybar_base" ]] && [[ -x "$_polybar_base/launch.sh" ]]; then
    if [[ -d "$_polybar_base/fonts" ]]; then
        mkdir -p ~/.local/share/fonts \
            && rm -f ~/.local/share/fonts/polybar-fonts \
            && ln -sf \
                "$_polybar_base/fonts" ~/.local/share/fonts/polybar-fonts
        mkdir -p $_logdir/fc-cache \
            && fc-cache -v \
                1>"$_logdir/fc-cache/log" 2>"$_logdir/fc-cache/err"
    fi
    mkdir -p "$_logdir/polybar" \
        && "$_polybar_base/launch.sh" \
            1>"$_logdir/polybar/log" 2>"$_logdir/polybar/err"
fi

# Window mananger
mkdir -p "$_logdir/bspwm"
exec bspwm 1>"$_logdir/bspwm/log" 2>"$_logdir/bspwm/err"

# Author: Blurgy <gy@blurgy.xyz>
# Date:   Dec 07 2020, 14:18 [CST]
