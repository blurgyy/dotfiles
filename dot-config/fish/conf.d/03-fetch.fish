if not string match --quiet --entire --regex '^/dev/tty[0-9]$' (tty)
  # When sourcing a file, exit only causes fish to skip the rest of the
  # file.  See man:exit(1) from a fish shell (so that the manpage is for
  # fish's builtin exit command.
  builtin exit
end

# Clear tty
clear

if type -q macchina
  macchina
end

# Author: Blurgy <gy@blurgy.xyz>
# Date:   Jan 13 2022, 20:40 [CST]
