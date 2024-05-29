# scalpel.nvim

**scalpel.nvim** is a Neovim plugin designed to expedite your find/replace workflow within a buffer. It sets up Neovim's native [`substitution`](https://neovim.io/doc/user/usr_10.html#10.2) command, automating some steps to eliminate excessive typing.

## Installation

Install **scalpel.nvim** with your preferred plugin manager. 

The following example shows the installation process using [lazy.nvim](https://github.com/folke/lazy.nvim). It sets the scalpel substitute keymap to `<leader>e`.

```lua
return {
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

## How to Use

Using **scalpel.nvim** is simple:

1. Move the cursor over the word you wish to replace.
2. Trigger the substitution with the `<leader>e` keymap.
3. Begin typing your desired substitution and hit return. Note that the original word is being captured, so if you would like to incorporate it into your replacement, use `\1`.

This plugin also supports visual mode selection for substitutions within a single line.

## Acknowledgments

This project was inspired by [Scalpel](https://github.com/wincent/scalpel), a Vimscript plugin I've used for many years. **scalpel.nvim** is my version reimagined and implemented in Lua for fun.
