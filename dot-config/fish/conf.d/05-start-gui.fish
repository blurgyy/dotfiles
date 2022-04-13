# Skip if current user is root
if string match --quiet --entire --regex '^0$' (id -u)
  builtin exit
end

# Only start a GUI session from tty2(wayland,sway) or tty3(xorg,i3)
if string match --quiet --entire --regex '^/dev/tty2$' (tty)  # wayland
  # Do not use `set -l` so that the variables are not restricted to current
  # scope (which is this `if` block) but also not exported to subprocesses.
  set protocol wayland
else if string match --quiet --entire --regex '^/dev/tty3$' (tty)  # xorg
  set protocol x11
else
  # When sourcing a file, exit only causes fish to skip the rest of the
  # file.  See man:exit(1) from a fish shell (so that the manpage is for
  # fish's builtin exit command.
  builtin exit
end

echo "Launching $protocol session"

# XDG Base Directories.  See the specifications at:
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
# The Arch Linux Wiki at: https://wiki.archlinux.org/title/XDG_Base_Directory
set -x XDG_CACHE_HOME "$HOME/.cache"
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_DATA_HOME "$HOME/.local/share"
set -x XDG_STATE_HOME "$HOME/.local/state"
## pam_systemd sets this already
#set -x XDG_RUNTIME_DIR "/run/user/(id -u)"

# Input method
set -x GTK_IM_MODULE "fcitx"
set -x QT_IM_MODULE "fcitx"
set -x XMODIFIERS "@im=fcitx"
set -x INPUT_METHOD "fcitx"
set -x SDL_IM_MODULE "fcitx"

# Set protocol-related environment variables:
#
# - XDG_SESSION_TYPE [wayland|x11]
#   Orders GUI applications to recognize current session type, this is not
#   imported into systemd environment by default, so explicitly defining it
#   here and import into systemd later.
# - QT_QPA_PLATFORM [wayland|xcb]
#   For most Qt applications, setting XDG_SESSION_TYPE to wayland should be
#   enough to order them to run with native wayland APIs, but some proprietary
#   applications such as zoom may not use system's implementations of Qt, thus:
#   Force "wayland" as Qt Platform Abstraction (QPA).
#   Reference:
#   - https://wiki.archlinux.org/title/Wayland#Qt
# - CLUTTER_BACKEND [wayland|x11]
#   Reference:
#   - https://wiki.archlinux.org/title/Wayland#Clutter
# - SDL_VIDEODRIVER [wayland|x11]
#   Reference:
#   - https://wiki.archlinux.org/title/Wayland#SDL2
# - MOZ_ENABLE_WAYLAND [1|0]
#   Enables native wayland for firefox
if string match --quiet --entire "wayland" "$protocol"
  set -x XDG_CURRENT_DESKTOP sway
  set -x XDG_SESSION_DESKTOP sway
  set -x XDG_SESSION_TYPE wayland
  set -x QT_QPA_PLATFORM wayland
  set -x CLUTTER_BACKEND wayland
  set -x SDL_VIDEODRIVER wayland
  set -x MOZ_ENABLE_WAYLAND 1
else
  set -x XDG_CURRENT_DESKTOP i3
  set -x XDG_SESSION_DESKTOP i3
  set -x XDG_SESSION_TYPE x11
  set -x QT_QPA_PLATFORM xcb
  set -x CLUTTER_BACKEND x11
  set -x SDL_VIDEODRIVER x11
  set -x MOZ_ENABLE_WAYLAND 0
end

# Set QPA theme to qt5ct, and install package "qt5ct" to configure icon theme
# for Qt5 applications.  See `~/.config/qt5ct/qt5ct.conf`.
# NOTE: There's a package called `qt6ct` that I also installed but not in use
# NOTE: here.
# Reference:
#   - https://wiki.archlinux.org/title/Wayland#Qt
#   > For the application "keepassxc", install `qt5ct` and set QPA theme to
#   > qt5ct to allow it to minimize to tray.
#   - https://wiki.archlinux.org/title/Qt#Configuration_of_Qt5_apps_under_environments_other_than_KDE_Plasma
set -x QT_QPA_PLATFORMTHEME qt5ct

## Setting "Style" in `~/.config/qt5ct/qt5ct.conf` to "kvantum" seems to be
## enough and below variable doesn't need to be set.
#set -x QT_STYLE_OVERWRITE kvantum

# Set cursor size to the same size as in gtk settings (refer to
# `~/.config/gtk-3.0/settings.ini`) in Qt5 applications _AND_ sway.
# Reference:
#   - https://forums.linuxmint.com/viewtopic.php?t=311591
#   - man:sway(1)#ENVIRONMENT
set -x XCURSOR_SIZE "{{{ gui.cursor-size }}}"
set -x XCURSOR_THEME "{{{ gui.cursor-theme }}}"

# Taken from <https://github.com/flameshot-org/flameshot/blob/master/docs/Sway%20and%20wlroots%20support.md>.
# REF: https://github.com/xmonad/xmonad/issues/126
set -x _JAVA_AWT_WM_NONREPARENTING 1

# Import environments to systemd for applications that might start as a
# systemd service (e.g. telegram-desktop), or indirectly started by an systemd
# service, (e.g. a freshly launched firefox via clicking a link from
# telegram-desktop)
systemctl --user import-environment \
  GTK_IM_MODULE QT_IM_MODULE XMODIFIERS INPUT_METHOD SDL_IM_MODULE \
  XDG_CACHE_HOME XDG_CONFIG_HOME XDG_DATA_HOME XDG_STATE_HOME \
  XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE \
  QT_QPA_PLATFORM CLUTTER_BACKEND SDL_VIDEODRIVER \
  QT_QPA_PLATFORMTHEME XCURSOR_SIZE XCURSOR_THEME \
  _JAVA_AWT_WM_NONREPARENTING \
  MOZ_ENABLE_WAYLAND

# Also import PATH variable into systemd, so that the custom
# ~/.local/bin/firefox script can be found by applications launched from
# systemd.
systemctl --user import-environment PATH

if string match --quiet --entire "x11" "$protocol"
  # If under an X session, remove any Wayland-related environment variable
  # from service manager.
  systemctl --user unset-environment WAYLAND_DISPLAY
end

# start WM for current display protocol.
if string match --quiet --entire "wayland" "$protocol"
  if lsmod | grep -q nvidia
    # Do not disable hardware cursors when using iGPU, because it leads to
    # cursors fail to hide when taking screenshots, it's a wlroots bug:
    #   - <https://gitlab.freedesktop.org/wlroots/wlroots/-/issues/2301>
    #   - <https://gitlab.freedesktop.org/wlroots/wlroots/-/issues/1363>
    # This setting was originally added since hardware cursor is not
    # rendering on an NVIDIA dGPU with 495+ driver which added GBM support
    # but still quite buggy.
    ## Fix cursor rendering with Nvidia proprietary driver
    #set -x WLR_NO_HARDWARE_CURSORS 1

    # According to this GitHub issue comment:
    # <https://github.com/swaywm/sway/issues/5642#issuecomment-680771073>
    # Specifying `WLR_DRM_DEVICES=$iGPU:$dGPU` will let the $iGPU do the
    # rendering and use llvmpipe to copy the buffer to the dGPU.  To make
    # sure /dev/dri/card0 is the iGPU, specify i915 in the MODULES array
    # in /etc/mkinitcpio.conf before other driver modules should work (I
    # think).
    #
    # Yet with the NVIDIA proprietary driver, this does not work, after
    # setting this, only the first GPU's connected monitor is displaying a
    # buffer, the other is frozen.
    #
    # Use `lspci` and `ls -l /dev/dri/by-path/` to determine how the cards
    # are ordered (e.g. if card0 is iGPU or dGPU).
    set -x WLR_DRM_DEVICES "/dev/dri/card0:/dev/dri/card1"

    exec sway --unsupported-gpu >>"$XDG_RUNTIME_DIR/sway.log" 2>&1
  else
    exec sway >>"$XDG_RUNTIME_DIR/sway.log" 2>&1
  end
else
  exec startx
end

# Author: Blurgy <gy@blurgy.xyz>
# Date:   Jan 08 2022, 01:02 [CST]
