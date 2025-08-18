#!/bin/zsh

##? List installed plugins
function plugin-list {
  local plugins=()

  for plugin in $(ls $ZPLUGINDIR); do
    if [[ -d "$ZPLUGINDIR/$plugin" ]]; then
      pushd "$ZPLUGINDIR/$plugin" > /dev/null # Change working directory

      # Determine if the plugin is a sparse-checkout
      if [[ "$(git config --get core.sparseCheckout)" == "true" ]]; then
        for subplugin in $(git sparse-checkout list); do
          plugins+="$plugin/$subplugin"
        done
      else
        plugins+="$plugin"
      fi

      popd > /dev/null # Change working directory back
    fi
  done

  if [[ $# == 0 ]]; then
    for plugin in $plugins; do
      echo $plugin
    done
  else
    for plugin in $plugins; do
      echo $plugin
    done | grep -E $1
  fi
}
