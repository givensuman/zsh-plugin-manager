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
source "${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}/zsh-plugin-manager/zsh-plugin-manager.zsh"
plugin source
```


```zsh
wget -qO- https://raw.githubusercontent.com/givensuman/zsh-plugin-manager/main/zsh-plugin-manager.zsh >> ~/.zshrc
```

## Testing

Run the test suite to verify functionality:

```zsh
cd tests
zsh run_tests.zsh
```

## Acknowledgements

The API is directly meant to emulate [fisher](https://github.com/jorgebucaran/fisher).

## License

[MIT](LICENSE.md)
