#!/bin/zsh

##? Display help command
function plugin-help {
  echo "Usage:"
  echo -e "\t${fg[blue]}plugin ${fg[green]}<command> ${fg[magenta]}[args]${reset_color}"
  echo ""
  echo "Commands:"
  echo -e "\t${fg[green]}install   ${fg[magenta]}[name...]${reset_color}   Install plugins through ${fg[yellow]}git${reset_color}"
  echo -e "\t${fg[green]}          ${fg[yellow]}--path${reset_color}      Specify a subpath of the target repository"
  echo -e "\t${fg[green]}          ${fg[yellow]}--branch${reset_color}    Specify a branch of the target repository"
  echo -e "\t${fg[green]}remove    ${fg[magenta]}[name...]${reset_color}   Remove plugins"
  echo -e "\t${fg[green]}update    ${fg[magenta]}[name...]${reset_color}   Update plugins"
  echo -e "\t${fg[green]}update    ${fg[magenta]}         ${reset_color}   Update all plugins"
  echo -e "\t${fg[green]}list      ${fg[magenta]}[regex]  ${reset_color}   List installed plugins"
  echo -e "\t${fg[green]}source    ${fg[magenta]}[name...]${reset_color}   Source plugins"
  echo -e "\t${fg[green]}source    ${fg[magenta]}         ${reset_color}   Source all plugins"
  echo -e "\t${fg[green]}help      ${fg[magenta]}         ${reset_color}   Display this help message"
  echo ""
  echo "Variables:"
  echo -e "\t${fg[magenta]}\$ZPLUGINDIR:${reset_color} ${ZPLUGINDIR}"
  echo ""
  echo "Initialization:"
  echo -e "\t${fg[gray]}# Add this to your ~/.zshrc"${reset_color}
  echo -e "\tsource ${fg[green]}\"\${ZPLUGINDIR}/zsh-plugin-manager/zsh-plugin-manager.zsh\"${reset_color}"
  echo -e "\tplugin source"
}

