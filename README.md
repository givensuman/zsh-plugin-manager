# zsh-plugin-manager

## Usage

Access the plugin through the `plugin` command:

```zsh
Usage: plugin <command> [args]
Commands:
        install   [name...]   Install plugins from GitHub
        remove    [name...]   Remove plugins from your machine
        update    [name...]   Update installed plugins
        update                Update all plugins
        list      [regex]     List all installed plugins

```

Install a plugin by running `plugin install`:

```zsh
plugin install givensuman/zsh-allclear
```

## Install

Grab the plugin:

```zsh
git clone https://github.com/givensuman/zsh-plugin-manager ${ZPLUGINDIR:-$HOME/.config/zsh/plugins}/zsh-plugin-manager
```

And add this to your `~/.zshrc`:

```zsh
ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}
for plugin in $ZPLUGINDIR/*; do
  if [[ -d $plugin ]]; then
    source $plugin/*.zsh
  fi
done
```

## Does the world need another ZSH plugin manager?

This is really a few functions meant to make managing plugins easier. The whole thing is <100 LOC and will likely not grow much in scope.

If you don't want to have this as a dependency, you can scrap the code in [./zsh-plugin-manager.zsh](./zsh-plugin-manager.zsh) to do with as you want, or append its contents directly to your `~/.zshrc` with something like:

```zsh
wget -qO- https://raw.githubusercontent.com/givensuman/zsh-plugin-manager/main/zsh-plugin-manager.zsh >> ~/.zshrc
```

## Acknowledgements

This codebase started from [zsh_unplugged](https://github.com/mattmc3/zsh_unplugged) project.
The API is directly meant to emulate [fisher](https://github.com/jorgebucaran/fisher).

## License

[MIT](LICENSE.md)
