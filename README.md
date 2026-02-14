# scalpel.nvim

**scalpel.nvim** is a Neovim plugin designed to expedite your find/replace workflow within a buffer. It sets up Neovim's native [`substitution`](https://neovim.io/doc/user/usr_10.html#10.2) command, automating some steps to reduce some typing.

![scalpel-nvim demo](scalpel.gif)

## Requirements

- Neovim >= 0.10.0

## Installation

Install **scalpel.nvim** with your preferred plugin manager.

The following example shows the installation process using [lazy.nvim](https://github.com/folke/lazy.nvim). It sets the scalpel substitute keymap to `<leader>e`.

```lua
{
  'wassimk/scalpel.nvim',
  version = "*",
  config = true,
  keys = {
    {
      '<leader>e',
      function()
        require('scalpel').substitute()
      end,
      mode = { 'n', 'x' },
      desc = 'substitute word(s)',
    },
  },
}
```

> [!NOTE]
> You can set the keymap to anything you wish.

## Usage

### Normal Mode

1. Move the cursor over the word to replace
2. Trigger the substitution with your keymap
3. Begin typing the desired substitution and hit return

All occurrences of the word in the buffer are highlighted and the substitution command is pre-filled with the word under the cursor.

### Visual Mode

1. Use visual mode (`v`) to select the word(s) to replace within a *single line*
2. Trigger the substitution with your keymap
3. Begin typing the desired substitution and hit return

All occurrences of the selected text in the buffer are highlighted and the substitution command is pre-filled with the selection.

### Visual Line Mode

1. Search for the word(s) to substitute with `*` or `/`
2. Use visual line mode (`V`) to highlight the lines to scope the substitution to
3. Trigger the substitution with your keymap
4. Begin typing the desired substitution and hit return

The substitution reuses your last search pattern and is scoped to the selected lines. The cursor is positioned in the replacement field so you can type the replacement immediately.

> [!TIP]
> The word(s) being replaced during substitution are available in the replacement text using `&`.

> [!NOTE]
> The search pattern uses Vim's very magic mode (`\v`), so characters like `.`, `+`, `*`, and `()` are treated as regex operators. This lets you use regex in your search patterns without extra escaping. If you need to match these characters literally, escape them with `\` (e.g. `\.` to match a period).

## Acknowledgments

This project was inspired by [Scalpel](https://github.com/wincent/scalpel), a Vimscript plugin I've used for many years. **scalpel.nvim** is my version, which was reimagined and implemented in Lua for fun.
