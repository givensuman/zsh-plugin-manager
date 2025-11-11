#!/bin/zsh

##? List installed plugins
function plugin-list {
   if [[ $1 =~ "--help" || $1 =~ "-h" ]]; then
     echo "Usage: plugin list [regex]"
     echo ""
     echo "Arguments:"
     echo "  regex    Optional regex to filter plugin names"
     return 0
   fi

  local plugins=()

   for plugin in $ZPLUGINDIR/*(/:t); do
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
  done

  if [[ $# == 0 ]]; then
    for plugin in $plugins; do
      echo $plugin
    done
  else # Filter with regex
    for plugin in $plugins; do
      echo $plugin
    done | grep -E $1
  fi
}
