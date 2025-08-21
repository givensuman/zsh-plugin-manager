#!/bin/zsh

##? Source plugins
function plugin-source {
  # TODO: Improve usage message
  if [[ $1 =~ "--help" || $1 =~ "-h" ]]; then
    echo "Usage plugin source [name...]"
    return 0
  fi

  function source-plugin-by-name {
    local plugin_location="$ZPLUGINDIR/$1"

    if [[ ! -d $plugin_location ]]; then
      echo -e "${fg[yellow]}Cannot find plugin \"$1\" at $plugin_location${reset_color}"
      return 1
    fi

    pushd $plugin_location > /dev/null # Change working directory

    local sourceable_files=$(ls $plugin_location | grep -E "\.zsh(-theme)?$")
    for file in $sourceable_files; do
      source $file
    done

    popd > /dev/null # Change working directory back
  }


  if [[ $# == 0 ]]; then
    plugin-list | while read -r; do
      source-plugin-by-name $REPLY
    done
  else
    for plugin in $@; do
      update-plugin-by-name $plugin
    done
  fi

  unset -f source-plugin-by-name
}
