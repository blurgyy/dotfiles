#!/usr/bin/env -S bash

set -Eeuo pipefail

_logdir="$HOME/.gy/local/log/polybar"
mkdir -p "$_logdir"

killall -q polybar || true

export _einterface=$(
    ip link | grep '^[0-9]' | cut -d':' -f2 | sed 's/ //g' | grep '^e' \
        || true
)
export _winterface=$(
    ip link | grep '^[0-9]' | cut -d':' -f2 | sed 's/ //g' | grep '^w' \
        || true
)
export _thermalzone=$(
    grep '^x86_pkg_temp$' /sys/class/thermal/thermal_zone*/type -l \
        | sed 's/[^0-9]//g' \
        || true
)
if command -v hostname >/dev/null; then
    polybar $(hostname) 1>"$_logdir"/log 2>"$_logdir"/err
else
    echo "Command 'hostname' not found, you may want to install" \
        "\`inetutils\`." >"$_logdir"/err
fi

# Author: Blurgy <gy@blurgy.xyz>
# Date:   Apr 28 2021, 01:53 [CST]
