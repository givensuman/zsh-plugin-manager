#!/bin/zsh

##? Install plugins through `git`
function plugin-install {
  # TODO: Improve usage message
  if [[ $# == 0 || $1 =~ "--help" || $1 =~ "-h" ]]; then
    echo "Usage: plugin install [name...]"
    return 0
  fi

  # For reasons I haven't figured out, ZSH loses
  # PATH access halfway through executing this function
  # TODO: It's freakin' Silverblue...
  local GIT_BIN=$(which git)
  local RM_BIN=$(which rm)

  ##? Parse out the repository name and git URL
  # @arg    $1 The plugin argument
  #
  # @return $1 The repository name
  # @return $2 The git URL
  function parse-plugin-information {
    local git_url=""
    local repo_name=""

    # If the argument is a URL
    if [[ $1 =~ ^https?:// || $1 =~ ^git@ ]]; then
      # Remove everything up to the last slash and the .git suffix
      local repo_name="${${1##*/}%.git}"
      local git_url="$1"
    # If the argument is a GitHub repo in the form of `user/repo`
    elif [[ $1 =~ ^[^/]+/[^/]+$ ]]; then
      local repo_name="${${1##*/}%.git}"
      local git_url="https://github.com/$1.git"
    else
      echo "${fg[yellow]}Invalid plugin name \"$1\"${reset_color}"
    fi

    echo "$repo_name $git_url"
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
      for plugin in "${positional_args[@]}"; do # Install multiple plugins
        plugin_information=(${(s: :)$(parse-plugin-information "$plugin")} )

        local repo_name="${plugin_information[1]}"
        local git_url="${plugin_information[2]}"

        $GIT_BIN clone "$git_url" "$ZPLUGINDIR/$repo_name"
      done
    fi
  else # Install a single plugin
    plugin_information=(${(s: :)$(parse-plugin-information "${positional_args[1]}")} )

    local repo_name="${plugin_information[1]}"
    local git_url="${plugin_information[2]}"

    if [[ ! "$branch" == "" ]]; then
      $GIT_BIN clone -b "$branch" "$git_url" "$ZPLUGINDIR/$repo_name"
    else
      $GIT_BIN clone "$git_url" "$ZPLUGINDIR/$repo_name"
    fi

    if [[ ! "$path" == "" ]]; then
      pushd "$ZPLUGINDIR/$repo_name" > /dev/null

      if [[ ! -d "$path" ]]; then
        echo "${fg[yellow]}Path \"$path\" is not a directory${reset_color}"
        popd > /dev/null
        $RM_BIN -rf "$ZPLUGINDIR/$repo_name"

        return 1
      fi

      if [[ ! "$(git config --get core.sparseCheckout)" == "true" ]]; then
        $GIT_BIN sparse-checkout init --cone
      fi

      $GIT_BIN sparse-checkout add "$path"

      popd > /dev/null
    fi
  fi

  unset -f parse-plugin-information
}
