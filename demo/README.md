# Demo GIF

`scalpel.gif` in the repo root is generated from `scalpel.tape` with [VHS](https://github.com/charmbracelet/vhs). Regenerate it whenever the plugin's behavior or the README demo should change.

## Requirements

- [VHS](https://github.com/charmbracelet/vhs#installation) (`brew install vhs`)
- Neovim >= 0.10.0
- [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads) (optional, VHS falls back to a default font)
- Network access on the first run, to clone [onedark.nvim](https://github.com/navarasu/onedark.nvim) into `/tmp`

## Regenerate

From the repo root:

```shell
vhs demo/scalpel.tape
```

This overwrites `scalpel.gif`. Commit it along with any tape changes.

## How it works

- `scalpel.tape` scripts the keystrokes. Setup runs hidden, so the GIF starts inside Neovim with the file already open.
- `init.lua` is a minimal config that loads only scalpel, onedark, and the `<leader>e` keymap from the main README, so personal config never shows up in the demo.
- The tape copies `lua/scalpel/init.lua` to `/tmp/scalpel-demo` and edits the copy, so rendering never modifies the repo.
- Steps wait on screen text (`Wait+Screen`), so if the plugin's behavior changes the render fails instead of recording a broken demo.
