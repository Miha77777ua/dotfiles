# dotfiles

My dotfiles (with 2 sub-repos included), cursors and wallpapers (all stowable)

![preview](./preview/preview.png)

## Installation

Firstly, install <u>GNU stow</u> from [here](https://www.gnu.org/software/stow/) or by using your favorite package manager

Then, ensure you have `git` and clone repo by running

```sh
git clone --recurse-submodules https://git.sr.ht/~miha77777ua/.dotfiles
```

Then, cd into cloned repo

```sh
cd dotfiles
```

Run `stow` for every package (ensure `~/.local/share/icons`, `~/.config` and `~/Pictures` exist before stowing, otherwise `stow` will create symlinks for them)

```sh
stow <name of the package, like nvim>
```

## Licensing

This repository is licensed under **MIT License** EXCEPT for:
- [`vis-lspc`](https://codeberg.org/muhq/vis-lspc) (`vis/.config/vis/plugins/vis-lspc`), which is licensed under **GPL-3.0**
- [`vis-commentary`](https://codeberg.org/luxanna/vis-autoclose) (`vis/.config/vis/plugins/vis-autoclose, which is licensed under **BSD-3-Clause**

dwl (`dwl/dwl`) (**GPL-3.0**) and someblocks (`someblocks/someblocks`) (**ISC**) are submodules
