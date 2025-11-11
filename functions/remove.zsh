#!/bin/zsh

# ISSUE: Removing a plugin with --path does not work

##? Remove plugins
function plugin-remove {
   if [[ $# == 0 || $1 =~ "--help" || $1 =~ "-h" ]]; then
     echo "Usage: plugin remove [name...|repo/subpath]"
     echo ""
     echo "Arguments:"
     echo "  name        Plugin name or repo/subpath for sparse installs"
     return 0
   fi

   for plugin in $@; do
     local repo_name="$plugin"
     local subpath=""
     if [[ $plugin == */* ]]; then
       repo_name="${plugin%%/*}"
       subpath="${plugin#*/}"
     fi
     local plugin_location="$ZPLUGINDIR/$repo_name"

     if [[ ! -d $plugin_location ]]; then
       echo -e "${fg[yellow]}Cannot find plugin \"$plugin\" at $plugin_location${reset_color}"
       return 1
     fi

     pushd "$plugin_location" > /dev/null # Change working directory

     # Determine if the plugin is a sparse-checkout
     if [[ "$(git config --get core.sparseCheckout)" == "true" ]]; then
       # Remove the plugin from the sparse-checkout file
       local git_config="$(git rev-parse --show-toplevel)/.git/info/sparse-checkout"

       local path_to_remove="$subpath"
       if [[ -z "$subpath" ]]; then
         # If no subpath specified, remove all
         path_to_remove=".*"
       fi

       if ! grep -v "^$path_to_remove$" "$git_config" > "$git_config.tmp"; then
         echo "${fg[yellow]}Failed to update sparse-checkout config${reset_color}"
         popd > /dev/null
         return 1
       fi
       mv "$git_config.tmp" "$git_config"
       if ! git sparse-checkout reapply; then
         echo "${fg[red]}Failed to reapply sparse-checkout${reset_color}"
         popd > /dev/null
         return 1
       fi

       # If no subpaths left, remove the entire directory
       if [[ -z "$(git sparse-checkout list)" ]]; then
         popd > /dev/null
         rm -rf "$plugin_location"
       else
         popd > /dev/null
       fi
    else
      popd > /dev/null # Change working directory back
      rm -rf $plugin_location
    fi
  done
}
