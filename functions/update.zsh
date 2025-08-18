#!/bin/zsh

##? Update plugins
function plugin-update {
  function update-plugin-by-name {
    local plugin_location="$ZPLUGINDIR/$1"

    if [[ ! -d $plugin_location ]]; then
      echo -e "${fg[yellow]}Cannot find plugin \"$1\" at $plugin_location${reset_color}"
      return 1
    fi

    # TODO: Some kind of feedback for updating process
    pushd $plugin_location > /dev/null # Change working directory
    git pull > /dev/null
    popd > /dev/null # Change working directory back
  }

  if [[ $# == 0 ]]; then
    plugin-list | while read -r; do
      update-plugin-by-name $REPLY
    done
  else
    for plugin in $@; do
      update-plugin-by-name $plugin
    done
  fi

  unset -f update-plugin-by-name
}
