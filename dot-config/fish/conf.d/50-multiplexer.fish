if status is-interactive
  if type -q tmux  # If tmux is installed
    # TMUX
    if not set -q TMUX  # If not inside a TMUX session
      set tsess "main"
      set default_wname "default"
      set wname (date '+%b-%d,%H-%M-%S')

      if set -q SSH_CONNECTION  # If inside an SSH session
        set wname "$wname [ssh]"
        set default_wname "$default_wname [ssh]"
      end

      if string match -q "/dev/tty*" (tty)  # Do not autostart tmux in tty
        echo "Not autostarting tmux in tty" >&2
      else if test 0 -eq (id -u)  # Do not autostart tmux as root
        echo "Not autostarting tmux as root" >&2
      else  # Start new TMUX session or attach to existing one
        if not tmux has-session -t $tsess 2>/dev/null
          # If session '$tsess' does not exist, create first
          tmux start-server
          tmux select-window -t $tsess:0 \; \
            rename-window $default_wname
        end

        exec tmux new-session -t $tsess \; \
          new-window -n $wname \; \
          select-window -t $wname
        # Note: This will always quit an ssh session regardless of the
        #     exit code of TMUX.
      end
    end
  end
end  # if status is-interactive

function k --description "Kill current window and leave current session"
  argparse -n k f/force -- $argv
  if set -q TMUX
    and not set -q NVIM_LISTEN_ADDRESS
    if test (tmux display-message -p '#{window_panes}') -gt 1
      and not set -q _flag_force
      echo "Not leaving session (multiple panes in current window)" >&2
      echo "Use `"(status current-command)" -f` to kill anyway" >&2
      echo >&2
      echo "* Panes in current window:" >&2
      tmux list-panes
      return 1
    else if test (tmux display-message -p '#{session_windows}') -gt 1
      tmux kill-window \; kill-session
      and echo "Window and session killed"
    else
      tmux kill-session
      and echo "Session killed"
    end
  else
    builtin exit $argv
  end
end

function ks --description "Kill a current or specified session"
  if set -q TMUX
    if test (count $argv) -gt 0
      tmux kill-session -t $argv[1]
      and echo "Session $argv[1] killed"
    else
      tmux kill-session
      and echo "Session killed"
    end
  else
    echo "No session to kill (tmux is not running, are you "(whoami)"?)" \
      >&2
  end
end

function kw --description "Kill a current or specified window"
  argparse -n kw f/force -- $argv
  if set -q TMUX
    if set -q NVIM_LISTEN_ADDRESS
      echo "Killing window is not allowed in a Vim terminal buffer" >&2
      return 1
    end
    if test (tmux display-message -p '#{window_panes}') -gt 1
      and not set -q _flag_force
      echo "Not killing window (multiple panes in current window)" >&2
      echo "Use `$0 -f` to kill anyway" >&2
      echo >&2
      echo "* Panes in current window:" >&2
      tmux list-panes
      return 2
    else if test (tmux display-message -p '#{session_windows}') -gt 1
      if test (count $argv) -gt 0
        tmux kill-window $argv[1]
        and echo "Window '$argv[1]' killed"
      else
        tmux kill-window
        and echo "Window killed"
      end
    else
      tmux kill-session
      and echo "Session killed"
    end
  else
    echo "No window to kill (tmux is not running, are you "(whoami)"?)." \
      >&2
    return 3
  end
end

function kp --description "Kill current pane"
  if set -q TMUX
    if set -q NVIM_LISTEN_ADDRESS
      echo "Killing pane is not allowed in a Vim terminal buffer" >&2
      return 1
    end
    if test (tmux display-message -p '#{window_panes}') -gt 1
      tmux kill-pane -t "$TMUX_PANE"
      and echo "Pane killed"
    else
      echo "Only one pane in current window. Use `kw` to kill" \
        "window" >&2
      return 2
    end
  else
    echo "No pane to kill (tmux is not running, are you "(whoami)"?)" >&2
    return 3
  end
end

function KK --description "Kill tmux server"
  if set -q TMUX
    tmux kill-server
  else
    echo "No tmux server to kill" >&2
  end
end

function nw --description "Create a new window (by default name)"
  if set -q TMUX
    if test (count $argv) -eq 0
      tmux new-window
      and echo "Created new window"
    else
      tmux new-window -n $argv[1]
      and echo "Created new window '$argv[0]'"
    end
  end
end

function rew --description "Rename current window"
  if set -q TMUX
    if test (count $argv) -ne 1
      echo "Usage: "(status current-command)" <new-name>" >&2
      return 1
    end
    tmux rename-window $argv[1]
    and echo "Renamed current window to '$argv[1]'"
  end
end

function hw --description "Goto window on the left"
  if set -q TMUX
    tmux previous-window
    and echo "Switched to window on the left"
  end
end

function lw --description "Goto window on the right"
  if set -q TMUX
    tmux next-window
    and echo "Switched to window on the right"
  end
end

function gw --description "Goto specified window"
  if set -q TMUX
    if test (count $argv) -ne 1
      echo "Usage: "(status current-command)" <window-id>|<window-name>"
      return 1
    end
    tmux select-window -t $argv[1]
    and echo "Switched to window '$argv[1]'"
  end
end

# Author: Blurgy <gy@blurgy.xyz>
# Date:   Oct 28 2021, 14:56 [CST]
