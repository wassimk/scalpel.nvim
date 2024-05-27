# scalpel.nvim
This Neovim plugin provides a quick find/replace within a buffer with the `<leader>e` keymap. It calls the built-in [`substitution`](https://neovim.io/doc/user/usr_10.html#10.2) command and sets up as much as possible to prevent you from typing so much.

### Installation

Install **scalpel** using your plugin manager of choice. For example, here it is using [lazy.nvim](https://github.com/folke/lazy.nvim).

```lua
{
  'wassimk/scalpel.nvim',
  version = "*",
  config = true
}
```

### Usage

Move the cursor over the word to be substituted and press `<leader>e`.

It will start a substitution for the word under the cursor.

Now press `/` and start typing your substitution. It also captures the word being substituted, so if you need it in your substitution use `\1`.

### Thanks

For years, I used a plugin named [scalpel](https://github.com/wincent/scalpel) for this. It's written in Vimscript, and this is my version written in Lua, for fun.

