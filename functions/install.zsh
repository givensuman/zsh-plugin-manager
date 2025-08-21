#!/bin/zsh

function plugin-install {
  # Define git binary path, necessary due to
  # PATH issues with nested functions
  git_bin=$(which git)

  # TODO: Improve usage message
  if [[ $# == 0 || $1 =~ "--help" || $1 =~ "-h" ]]; then
    echo "Usage: plugin install [name...]"
    return 0
  fi

  function install-plugin-by-arg {
    # Taken in as arguments
    local plugin_arg=$1
    local path=$2
    local branch=$3
    # Necessary for PATH issues with 
    # nested functions

    # Fill in variables
    local git_url=""
    local repo_name=""

    # If the `plugin_arg` is a URL
    if [[ $plugin_arg =~ ^https?:// || $plugin_arg =~ ^git@ ]]; then
      # Use string manipulation to get the repo name without basename
      # This removes everything up to the last slash and the .git suffix
      local repo_name="${${plugin_arg##*/}%.git}"
      local git_url="$plugin_arg"
    # If the `plugin_arg` is a GitHub repo in the form of `user/repo`
    elif [[ $plugin_arg =~ ^[^/]+/[^/]+$ ]]; then
      # Parse repo name out
      local repo_name="${${plugin_arg##*/}%.git}"
      local git_url="https://github.com/$plugin_arg.git"
    else
      echo "${fg[yellow]}Invalid plugin name \"$plugin_arg\"${reset_color}"
    fi

    echo "repo_name: $repo_name"
    echo "git_url: $git_url"
    echo ""
    echo "plugin_arg: $plugin_arg"
    echo "path: $path"
    echo "branch: $branch"


    # Handle cases where directory exists
    if [[ -d "$ZPLUGINDIR/$repo_name" ]]; then
      pushd "$ZPLUGINDIR/$repo_name" > /dev/null

      if [[ $path != "" ]]; then
        if [[ "$(git config --get core.sparseCheckout)" == "true" ]]; then
          ($git_bin sparse-checkout add "$path") > /dev/null

          popd > /dev/null
          # TODO: Error message
          return $?
        else
          echo "${fg[yellow]}Plugin parent \"$repo_name\" exists and is is not a sparse-checkout${reset_color}"

          popd > /dev/null
          return 1
        fi
      else # May be sparse-checkout
        if [[ "$(git config --get core.sparseCheckout)" == "true" ]]; then
          ($git_bin sparse-checkout disable) > /dev/null

          popd > /dev/null
          # TODO: Error message
          return $?
        else # Not a sparse-checkout, directory exists, path not specified
          echo "${fg[yellow]}Plugin \"$repo_name\" already installed${reset_color}"

          popd > /dev/null
          return 1
        fi
      fi
    fi

    # Install the plugin
    if [[ $branch != "" ]]; then
      ($git_bin clone -b "$branch" "$git_url" "$ZPLUGINDIR/$repo_name") > /dev/null
      # TODO: Error message
    else
      ($git_bin clone "$git_url" "$ZPLUGINDIR/$repo_name") > /dev/null
      # TODO: Error message
    fi

    if [[ $path != "" ]]; then
      pushd "$ZPLUGINDIR/$repo_name" > /dev/null

      git sparse-checkout init --cone > /dev/null
      git sparse-checkout add "$path" > /dev/null
      # TODO: Error message
    fi
  }

  local path=""
  local branch=""
  local positional_args=()

  while [[ $# != 0 ]]; do
    case $1 in
      -p|--path)
        path="$2"
        shift
        shift
        ;;
      -b|--branch)
        branch="$2"
        shift
        shift
        ;;
      -*|--*)
        echo "${fg[yellow]}Unknown option \"$1\"${reset_color}"
        return 1
        ;;
      *) 
        positional_args+=("$1")
        shift
        ;;
    esac
  done

  if [[ $#positional_args == 0 ]]; then
    echo "${fg[yellow]}No plugin name specified${reset_color}"
    return 1
  fi

  if [[ $#positional_args > 1 ]]; then
    if [[ "$path" != "" || "$branch" != "" ]]; then
      echo "${fg[yellow]}Cannot specify path and branch for multiple plugins${reset_color}"
    else
      for plugin in "$positional_args[@]"; do
        install-plugin-by-arg "$plugin" "" ""
      done
    fi
  else
    # Install a single plugin
    install-plugin-by-arg "${positional_args[1]}" "$path" "$branch"
  fi

  unset -f install-plugin-by-arg
}
