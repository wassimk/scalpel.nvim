--
-- scalpel.lua
--

local function word_exists_above_cursor(word)
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  for i = current_line - 1, 1, -1 do
    local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
    if string.find(line, word) then
      return true
    end
  end
  return false
end

local function substitute_current_word()
  local word = vim.fn.expand('<cword>')
  local substituation_command_down = ':,$s/\\v(' .. word .. ')//gc'
  local repeat_from_top_to_current_line = "|1,''-&&"
  local cursor_move_to_replace_pattern

  if word_exists_above_cursor(word) then
    substituation_command_down = substituation_command_down .. repeat_from_top_to_current_line
    cursor_move_to_replace_pattern = '<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>'
  else
    cursor_move_to_replace_pattern = '<Left><Left><Left>'
  end

  local cursor_move = vim.api.nvim_replace_termcodes(cursor_move_to_replace_pattern, true, false, true)

  vim.api.nvim_feedkeys(substituation_command_down .. cursor_move, 'n', true)
end

vim.keymap.set('n', '<leader>e', substitute_current_word, { desc = 'Substite current word in file' })
