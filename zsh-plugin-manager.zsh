#!/bin/zsh

autoload -U colors && colors

local ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}

local fns_dir="${ZPLUGINDIR}/zsh-plugin-manager/functions"
local fns=(
  # "install"
  "update"
  # "remove"
  "list"
  "help"
  "source"
)

for fn in $fns; do
  local import="${fns_dir}/${fn}.zsh"

  if [[ ! -f $import ]]; then
    echo -e "${fg[red]}Your plugin manager is missing files${reset_color}"
    echo "Reinstall from https://github.com/givensuman/zsh-plugin-manager"
    return 1
  else
    source $import
  fi
done

##? https://github.com/givensuman/zsh-plugin-manager
function plugin {
  if (( $# == 0 )); then
    plugin-help
    return 1
  fi

  case $1 in
    install) shift; plugin-install $@ ;;
    update)  shift; plugin-update  $@ ;;
    remove)  shift; plugin-remove  $@ ;;
    list)    shift; plugin-list    $@ ;;
    "source")shift; plugin-source  $@ ;;
    *) { plugin-help; return 1; }     ;;
  esac
}
