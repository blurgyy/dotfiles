function cg --description "Goto nearest git root above current directory"
  if set -l cur (tt gr 2>/dev/null)
    cd $cur
  end
end

# Author: Blurgy <gy@blurgy.xyz>
# Date:   Oct 29 2021, 15:54 [CST]
