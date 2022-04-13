if status is-interactive
  # Manage prompt with starship
  starship init fish | source

  # Use vi-like keybindings
  fish_vi_key_bindings

  # Enable fuzzy finder keybindings (<C-r>, <C-t>, <M-c>)
  fzf_key_bindings
  ## or..
  #skim_key_bindings

  function fish_greeting
    # Write motd here ..
  end

  # Install `libnotify` to enable this
  if command -v notify-send >/dev/null;
    and not set -q SSH_CONNECTION;
    and not test (id -u) -eq 0
    and not string match --quiet --entire --regex '^/dev/tty\d$' (tty)
    __notify_when_long_running_process_finishes
  end
end

# Author: Blurgy <gy@blurgy.xyz>
# Date:   Oct 28 2021, 14:23 [CST]
