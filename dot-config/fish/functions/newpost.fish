function newpost \
  --description "Create a post file"
  set today (date +'%Y-%m-%d')
  set now (date +'%T')
  set zone (date +'%:z')

  set -l name (string join '-' $argv)

  set filename "$today-$name.md"

  touch $filename

  echo --- >>$filename
  echo "title: " >>$filename
  echo "date: \"$today $now $zone\"" >>$filename
  echo "tags:" >>$filename
  echo "  - " >>$filename
  echo --- >>$filename
  echo >>$filename
  echo "<!-- abstract goes here -->" >>$filename
  echo >>$filename
  echo --- >>$filename >>$filename
  echo >>$filename
  echo "<!-- main content begins -->" >>$filename

  echo New post created at: (set_color -u)$filename(set_color normal)
end

# Author: Blurgy <gy@blurgy.xyz>
# Date:   Dec 29 2021, 23:22 [CST]
