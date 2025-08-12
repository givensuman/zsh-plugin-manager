ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}

##? Clone each plugin, identify its init file, source it, and add it to your fpath
function _plugin-install {
  local repo plugdir initfile initfiles=()

  for repo in $@; do
    plugdir=$ZPLUGINDIR/${repo:t}
    initfile=$plugdir/${repo:t}.plugin.zsh
    if [[ ! -d $plugdir ]]; then
      printf "Installing $repo..."
      git clone -q --depth 1 --recursive --shallow-submodules \
        https://github.com/$repo $plugdir
      printf "\tdone\n"
    else 
      echo "There is already a plugin named $repo, skipping."
    fi
    if [[ ! -e $initfile ]]; then
      initfiles=($plugdir/*.{plugin.zsh,zsh-theme,zsh,sh}(N))
      (( $#initfiles )) || { echo >&2 "No sourceable files found for $repo" && continue }
      ln -sf $initfiles[1] $initfile
    fi
    fpath+=$plugdir
    (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
  done
}

##? Traverse through each plugin and `git pull`
function _plugin-update {
  for plugin in $ZPLUGINDIR/*/.git(/); do
    printf "Updating ${plugin:h:t}..."
    command git -C "${plugin:h}" pull -q --ff --recurse-submodules --depth 1 --rebase --autostash
    printf "\tdone\n"
  done
}

##? List all installed plugins
function _plugin-list {
  if [[ -n $1 ]]; then
    ls $ZPLUGINDIR | grep -E "$1"
  else
    for plugin in $(ls $ZPLUGINDIR); do
      echo $plugin
    done
  fi
}

##? Remove each plugin
function _plugin-remove {
  local abort=false

  # Check if all specified plugins exist before doing anything.
  for d in "$@"; do
    if [[ ! -d "$ZPLUGINDIR/$d" ]]; then
      echo "Error: plugin $d not found" >&2
      abort=true
    fi
  done

  # If any plugin was missing, exit the function.
  if [[ "$abort" == "true" ]]; then
    echo "Aborting. No plugins were removed." >&2
    return 1
  fi

  # If all checks passed, proceed with removal.
  for d in "$@"; do
    echo "Removing $d..."
    rm -rf "$ZPLUGINDIR/$d"
  done
}

##? Display help command
function _plugin-help {
  echo "Usage: plugin <command> [args]"
  echo "Commands:"
  printf "\tinstall   [name...]   Install plugins from GitHub\n"
  printf "\tremove    [name...]   Remove plugins from your machine\n"
  printf "\tupdate    [name...]   Update installed plugins\n"
  printf "\tupdate                Update all plugins\n"
  printf "\tlist      [regex]     List all installed plugins\n"
  echo ""
}

##? https://github.com/givensuman/zsh-plugin-manager
function plugin {
  if (( $# == 0 )); then
    _plugin-help
    return 1
  fi

  case $1 in
    install) shift; _plugin-install $@ ;;
    update)  shift; _plugin-update  $@ ;;
    remove)  shift; _plugin-remove  $@ ;;
    list)    shift; _plugin-list    $@ ;;
    *)               _plugin-help       ;;
  esac
}
