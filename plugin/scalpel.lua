--
-- scalpel.lua
--

local function substitute_current_word()
  local word = vim.fn.expand('<cword>')
  local pattern = ':%s/\\v(' .. word .. ')'
  vim.api.nvim_feedkeys(pattern, 'n', true)
end

vim.keymap.set('n', '<leader>e', substitute_current_word, { desc = 'Substite current word in file' })
