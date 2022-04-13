# Unset WINIT_UNIX_BACKEND, because Alacritty is called with
# WINIT_UNIX_BACKEND=x11 to make fcitx5 work properly, other applications
# launched from such an instance of Alacritty may as well use X11 as backend,
# I want to use wayland as backend as most as possible, so unset the variable
# if it exists.
set -q WINIT_UNIX_BACKEND
and set -e WINIT_UNIX_BACKEND

# Update GPG_TTY for every session
set -x GPG_TTY (tty)

# If `node` is not executable but `fnm` is installed, setup related
# environments
if not type -q node
  and type -q fnm
  fnm env | source
  fnm use 14 --install-if-missing --log-level=quiet
end

# Author: Blurgy <gy@blurgy.xyz>
# Date:   Feb 16 2022, 17:27 [CST]
