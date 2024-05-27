--
-- scalpel.lua
--

local function substitute_current_word()
  local word = vim.fn.expand('<cword>')
  local pattern = ':,$s/\\v(' .. word .. ")//gc|:undojoin|1,''-&&"

  local cursor_move = vim.api.nvim_replace_termcodes(
    '<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>',
    true,
    false,
    true
  )

  vim.api.nvim_feedkeys(pattern .. cursor_move, 'n', true)
end

vim.keymap.set('n', '<leader>e', substitute_current_word, { desc = 'Substite current word in file' })
