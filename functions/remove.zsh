#!/bin/zsh

function plugin-remove {
  # TODO: Improve usage message
  if [[ $# == 0 || $1 =~ "--help" || $1 =~ "-h" ]]; then
    echo "Usage: plugin remove [name...]"
    return 0
  fi

  for plugin in $@; do
    local plugin_location="$ZPLUGINDIR/$plugin"

    if [[ ! -d $plugin_location ]]; then
      echo -e "${fg[yellow]}Cannot find plugin \"$1\" at $plugin_location${reset_color}"
      return 1
    fi

    pushd "$ZPLUGINDIR/$plugin" > /dev/null # Change working directory

    # Determine if the plugin is a sparse-checkout
    if [[ "$(git config --get core.sparseCheckout)" == "true" ]]; then
      # Remove the plugin from the sparse-checkout file
      local git_config="$(git rev-parse --show-toplevel)/.git/info/sparse-checkout"

      grep -v "${plugin##*/}" $git_config > "$git_config.tmp"
      if [[ ! -f "$git_config.tmp" ]]; then
        # TODO: Improve error message
        echo "${fg[yellow]}Something went wrong${reset_color}"
      fi
      mv "$git_config.tmp" "$git_config"
      git sparse-checkout reapply

      popd > /dev/null # Change working directory back
    else
      popd > /dev/null # Change working directory back
      rm -rf $plugin_location
    fi
  done
}
