function fish_update_abbrs --description "Forcefully reload fish abbrs from $XDG_CONFIG_HOME/fish/conf.d/02-abbrs.fish"
  set -l uvarfile "$XDG_CONFIG_HOME/fish/fish_variables"
  set -l srcfile "$XDG_CONFIG_HOME/fish/conf.d/02-abbrs.fish"

  if test -f "$srcfile"
    if test -f "$uvarfile"
      # Clean up existing fish abbrs from ~/.config/fish/fish_variables
      sed -e '/^SETUVAR _fish_abbr/d' -i "$uvarfile"
    end
    # Reload configured abbrs from file
    __FORCE_UPDATE_ABBRS= source "$srcfile"
  else
    echo (set_color -r red)Error: "$srcfile" does not exist(set_color normal)
    return 1
  end
end

# Author: Blurgy <gy@blurgy.xyz>
# Date:   Feb 16 2022, 12:50 [CST]
