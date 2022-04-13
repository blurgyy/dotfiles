complete -c dt-cli -f

# Options
complete -c dt-cli -s c -l config-path -rka "(__fish_complete_suffix .toml)" \
  -d "Specifies path to config file"
complete -c dt-cli -s l -l local-name -x \
  -d "Specifies name(s) of the local group(s) to be processed"

# Flags
complete -c dt-cli -s d -l dry-run \
  -d "Shows changes to be made without actually syncing files"
complete -c dt-cli -s h -l help -x \
  -d "Prints help information"
complete -c dt-cli -s q -l quiet \
  -d "Decreases logging verbosity"
complete -c dt-cli -s V -l version -x \
  -d "Prints version information"
complete -c dt-cli -s v -l verbose \
  -d "Increases logging verbosity"

# Author: Blurgy <gy@blurgy.xyz>
# Date:   Oct 29 2021, 12:08 [CST]
