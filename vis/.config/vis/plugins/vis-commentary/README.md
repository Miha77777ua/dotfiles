## vis-commentary

`vis-commentary` aims to port Tim Pope's [vim-commentary](https://github.com/tpope/vim-commentary) to [vis](https://github.com/martanne/vis).

### Installation
Clone the repo to your vis plugins directory (`~/.config/vis/plugins`) and add this to your `visrc.lua`:
```
require("plugins/vis-commentary")()
```

### Usage

| Keybind | Description |
|---------|-------------|
| `gcc`   | Toggle comment of the current line in NORMAL mode.|
| `gc`    | Toggle comment on the target of a motion (for example: `gj` to comment this and next line) |

### Configuration

If you do not wish the default keybinds, you may change the bindings via using the functions

MapBlocks(key)
MapLine(key)

### API

comments_repl: table -> {lexer: table}
	lexer -> {P="prefix", S="suffix", L="line"}
	WARNING: P or L must be set or an error will occur
function MapBlocks(key: string|nil) -- Binds "gc"|<key> to comment selections/block
function MapLine(key: string|nil) -- Binds "gcc"|<key> to comment the current line
function SetDefaults() -- Sets default keybindings

### Bugs

* multiline block comments with indentation endings are not supported. (rst)

### Notes

Should you find bugs or unsupported languages, please report them.
