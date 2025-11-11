#!/bin/zsh

##? Source plugins
function plugin-source {
   if [[ $1 =~ "--help" || $1 =~ "-h" ]]; then
     echo "Usage: plugin source [name...|repo/subpath]"
     echo ""
     echo "Arguments:"
     echo "  name        Plugin name or repo/subpath for sparse installs"
     return 0
   fi

  typeset -TUg +x FPATH=$ZPLUGINDIR:$FPATH fpath

   function source-plugin-by-name {
     local repo_name="$1"
     local subpath=""
     if [[ $1 == */* ]]; then
       repo_name="${1%%/*}"
       subpath="${1#*/}"
     fi
     local plugin_location="$ZPLUGINDIR/$repo_name"

     if [[ ! -d $plugin_location ]]; then
       echo -e "${fg[yellow]}Cannot find plugin \"$1\" at $plugin_location${reset_color}"
       return 1
     fi

     local source_dir="$plugin_location"
     if [[ -n "$subpath" ]]; then
       source_dir="$plugin_location/$subpath"
       if [[ ! -d $source_dir ]]; then
         echo -e "${fg[yellow]}Cannot find subpath \"$subpath\" in plugin \"$repo_name\"${reset_color}"
         return 1
       fi
     fi

     pushd $source_dir > /dev/null # Change working directory

     local sourceable_files=()
     for file in *.zsh(.N) *.zsh-theme(.N); do
       sourceable_files+=("$file")
     done
     for file in $sourceable_files; do
       source "$file"
     done

     popd > /dev/null # Change working directory back
   }


  if [[ $# == 0 ]]; then
    plugin-list | while read -r; do
      source-plugin-by-name $REPLY
    done
   else
     for plugin in $@; do
       source-plugin-by-name $plugin
     done
   fi

  unset -f source-plugin-by-name
}
