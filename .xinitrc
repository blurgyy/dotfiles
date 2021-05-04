#!/bin/sh

if [[ -n $_xinitrc_loaded ]]; then
    echo "Not recursively loading ~/.xinitrc" >&2
else
_xinitrc_loaded=1  # To prevent recursive loading of this file

# From /etc/X11/xinit/xinitrc ================================================
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

# Custom configs =============================================================

# Failure proof
set -Eeuo pipefail

# Local xinitrc files to load.  No need to worry about recursive loading of
# this xinitrc file, as this file uses a variable `_xinitrc_loaded` to prevent
# recursive loading.
for i in ~/.xinitrc*; do
    source $i
done

# Log directories
_logdir=~/.gy/local/log

# Compositor
if command -v picom >/dev/null; then
    mkdir -p "$_logdir/picom"
    picom --experimental-backends -cb \
        1>"$_logdir/picom/log" 2>"$_logdir/picom/err"
fi

# Notification daemon
if command -v deadd-notification-center >/dev/null; then
    mkdir -p "$_logdir/ntfd"
    deadd-notification-center \
        1>"$_logdir"/ntfd/log 2>"$_logdir"/ntfd/err &
fi

# Input method
if command -v fcitx5 >/dev/null; then
    mkdir -p "$_logdir/fcitx5"
    fcitx5 1>"$_logdir/fcitx5/log" 2>"$_logdir/fcitx5/err" &
fi

# [Start]
/bin/systemctl --user start redshift telegram
# [/Start]

# Window mananger
mkdir -p "$_logdir/bspwm"
# exec bspwm 1>"$_logdir/bspwm/log" 2>"$_logdir/bspwm/err"
bspwm 1>"$_logdir/bspwm/log" 2>"$_logdir/bspwm/err"

# [Stop]
/bin/systemctl --user stop redshift telegram
# [/Stop]

fi  # To prevent recursive loading of this file, see file beginning.

# Author: Blurgy <gy@blurgy.xyz>
# Date:   Dec 07 2020, 14:18 [CST]
