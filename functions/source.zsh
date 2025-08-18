#!/bin/zsh

##? Source plugins
function plugin-source {
  function source-plugin-by-name {
    local plugin_location="$ZPLUGINDIR/$1"

    if [[ ! -d $plugin_location ]]; then
      echo -e "${fg[yellow]}Cannot find plugin \"$1\" at $plugin_location${reset_color}"
      return 1
    fi

    pushd $plugin_location > /dev/null # Change working directory
    echo $plugin_location

    local sourceable_files=$(ls $plugin_location | grep ".zsh$")
    echo $sourceable_files
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
