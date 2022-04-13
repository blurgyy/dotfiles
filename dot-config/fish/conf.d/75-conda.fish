function cinit --description "Initialize conda executable"
  if not set -q _conda_root
    echo "Anaconda cannot be found under ~/anaconda3, nor /opt/anaconda" \
      >&2
    return 1
  end
  $_conda_root/bin/conda shell.fish hook | source
end

function cact --description "Activate current or specified conda environment"
  if not set -q _conda_root
    echo "Anaconda cannot be found under ~/anaconda3, nor /opt/anaconda" \
      >&2
    return 1
  end
  if set -q CONDA_PREFIX
    printf "Already in a conda environment " >&2
    printf "("(set_color -ou bryellow)"$CONDA_DEFAULT_ENV"(set_color normal)"), " >&2
    echo "run `"(set_color brgreen)"cdeact"(set_color normal)"` first" >&2
    return 2
  end
  if test (count $argv) -gt 0
    $_conda_root/bin/conda shell.fish activate $argv[1] | source
  else if set -l cur (basename (tt gr) 2>/dev/null)
    $_conda_root/bin/conda shell.fish activate $cur | source
  else
    echo "Usage: "(status current-command)" <env-name>" >&2
    return 3
  end
end

function cdeact \
  --description "Deactivate currently activated conda environment"
  if not set -q _conda_root
    echo "Anaconda cannot be found under ~/anaconda3, nor /opt/anaconda" \
      >&2
    return 1
  end
  $_conda_root/bin/conda shell.fish deactivate $argv | source
  set -e CONDA_EXE CONDA_SHLVL CONDA_PYTHON_EXE _CE_CONDA
end

function clist --description "List all currently installed conda envs"
  if not set -q _conda_root
    echo "Anaconda cannot be found under ~/anaconda3, nor /opt/anaconda" \
      >&2
    return 1
  end

  set -l conda_envs_dir $HOME/.conda/envs
  if not test -d $conda_envs_dir
    or test (count (command ls $conda_envs_dir)) -eq 0
    echo "No envs installed under $conda_envs_dir" >&2
    return 2
  end

  for envname in (command ls $conda_envs_dir)
    if string match --regex "$envname\$" $CONDA_PREFIX >/dev/null
      set_color --bold brwhite
      printf "  " >&2
      set_color --underline
    else
      set_color white
      printf "  " >&2
    end
    echo $envname
    set_color normal
  end
end

function ccreate --description "Create current or specified conda environment"
  if not set -q _conda_root
    echo "Anaconda cannot be found under ~/anaconda3, nor /opt/anaconda" \
      >&2
    return 1
  end
  argparse -n ccreate y n/name= no-default-packages -- $argv
  if not set -q _flag_name
    if set -l cur (basename (tt gr) 2>/dev/null)
      if clist 2>/dev/null | grep -q $cur 2>/dev/null
        echo "Not creating existing env '$cur'" >&2
        return 2
      else
        cinit
        # Omit `env` here (use `conda` instead of `conda env`).
        # Reference:
        # https://github.com/conda/conda/issues/3859#issuecomment-260001212
        conda create -n "$cur"
      end
    end
  else if string length -q $_flag_name
    cinit
    conda create -n $_flag_name $_flag_no_default_packages $_flag_y $argv
  else
    echo "Usage: "(status current-command)" [-n <env-name>]" \
      "[--no-default-packages] [-y]" >&2
  end
end

function crm --description "Remove specified conda environment"
  if not set -q _conda_root
    echo "Anaconda cannot be found under ~/anaconda3, nor /opt/anaconda" \
      >&2
    return 1
  end
  if test (count $argv) -ne 1
    echo "Usage: "(status current-command)" <env-name>" >&2
    return 2
  end
  if string match --regex '^'$argv[1]'$' $CONDA_DEFAULT_ENV >/dev/null
    printf "Requested to delete currently activated env, "
    echo "run `"(set_color brgreen)"cdeact"(set_color normal)"` first" >&2
    return 3
  end
  cinit
  conda env remove --name $argv[1]
end

# Author: Blurgy <gy@blurgy.xyz>
# Date:   Oct 29 2021, 01:25 [CST]
